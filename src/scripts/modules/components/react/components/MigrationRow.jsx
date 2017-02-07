import React from 'react';
import Promise from 'bluebird';
import _ from 'underscore';
import {Table} from 'react-bootstrap';
import {RefreshIcon} from 'kbc-react-components';
import {fromJS, List, Map} from 'immutable';
import {Link} from 'react-router';
import SapiTableLink from './StorageApiTableLink';
import ApplicationStore from '../../../../stores/ApplicationStore';
import InstalledComponentsActionCreators from '../../InstalledComponentsActionCreators';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import {Modal, TabbedArea, TabPane, Alert} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';
import jobsApi from '../../../jobs/JobsApi';
import DockerActionFn from '../../DockerActionsApi';
import date from '../../../../utils/date';
import JobStatusLabel from '../../../../react/common/JobStatusLabel';
import {Check} from 'kbc-react-components';
import Tooltip from '../../../../react/common/Tooltip';
import InstalledComponentsStore from '../../stores/InstalledComponentsStore';
import ComponentConfigurationLink from './ComponentConfigurationLink';

const PERNAMENT_MIGRATION_COMPONENTS = [
  'ex-db',
  'ex-gooddata',
  'ex-google-analytics',
  'ex-google-drive',
  'wr-db-mysql',
  'wr-db-oracle',
  'wr-db-redshift'
];

const MIGRATION_COMPONENT_ID = 'keboola.config-migration-tool';
const MIGRATION_ALLOWED_FEATURE = 'components-migration';

const componentNameMap = Map({
  'ex-gooddata': 'keboola.ex-gooddata',
  'ex-google-analytics': 'keboola.ex-google-analytics',
  'ex-google-drive': 'keboola.ex-google-drive',
  'wr-db-mysql': 'keboola.wr-db-mysql',
  'wr-db-oracle': 'keboola.wr-db-oracle',
  'wr-db-redshift': 'keboola.wr-redshift-v2'
});

export default React.createClass({
  propTypes: {
    componentId: React.PropTypes.string.isRequired
  },

  getInitialState() {
    return {
      loadingStatus: false,
      isLoading: false,
      status: null,
      showModal: false
    };
  },

  /* componentDidMount() {
   *   if (!this.state.status) {
   *     this.loadStatus();
   *   }
   * },*/

  loadStatus(additionalState) {
    const newState = _.extend({}, additionalState, {loadingStatus: true});
    this.setState(newState);
    const params = {
      configData: {
        parameters: {
          component: this.props.componentId
        }
      }
    };
    const componentsPromise = InstalledComponentsActionCreators.loadComponentsForce();
    const lastJobPromise = this.fetchLastMigrationJob(this.props.componentId);
    const statusPromise = DockerActionFn(MIGRATION_COMPONENT_ID, 'status', params);
    return Promise.props(
      {
        components: componentsPromise,
        job: lastJobPromise,
        status: statusPromise
      }
    ).then((result) => {
      return this.setState({
        job: result.job,
        status: fromJS(result.status),
        loadingStatus: false
      });
    });
  },

  /* getDefaultProps() {
   *  return {
   *    buttonType: 'danger'
   *  };
   *},*/

  canMigrate() {
    const isPernament = PERNAMENT_MIGRATION_COMPONENTS.indexOf(this.props.componentId) >= 0;
    return isPernament || ApplicationStore.hasCurrentAdminFeature(MIGRATION_ALLOWED_FEATURE);
  },

  renderTabTitle(title, helptext) {
    return (
      <span>
        {title}
        <Tooltip tooltip={helptext}>
          <span className="fa fa-fw fa-question-circle" />
        </Tooltip>
      </span>
    );
  },

  render() {
    if (!this.canMigrate()) {
      return null;
    }

    const configHelpText = 'List of all configurations that will be migrated and their new counterparts';
    const orchHelpText = 'List of orchestrations containing tasks of either old db extractor or new db extractors. After succesfull migration there should be only new db extractor tasks.';

    const body = (
      this.state.status ?
      <span>
        <div>
          <TabbedArea key="tabbedarea" animation={false}>

            <TabPane key="general" eventKey="general" tab={this.renderTabTitle('Affected Configurations', configHelpText)}>
              {this.renderConfigStatus()}
            </TabPane>
            <TabPane key="datasample" eventKey="datasample" tab={this.renderTabTitle('Affected Orchestrations', orchHelpText)}>
              {this.renderOrhcestrationsStatus()}
            </TabPane>
          </TabbedArea>
        </div>
      </span>
    : 'Loading migration status...'
    );
    const dialogTitle = this.renderDialogTitle();
    const footer = (
      <ConfirmButtons
        saveStyle="success"
        saveLabel="Migrate"
        isSaving={this.state.isLoading}
        isDisabled={this.state.isLoading || this.state.loadingStatus}
        onSave={this.onMigrate}
        onCancel={this.hideModal}
      />
    );
    const dialogProps = {
      show: this.state.showModal,
      onHide: this.hideModal,
      bsSize: 'large'
    };
    return (
      <div className="row kbc-header">
        {this.renderInfoRow()}
        {this.renderModal(dialogTitle, body, footer, dialogProps)}
      </div>
    );
  },

  renderMigrationButton() {
    return (
      <button
        onClick={this.showModal}
        type="button"
        disabled={this.state.isLoading}
        type="sumbit" className="btn btn-success">
        Proceed to Migration
        {this.state.isLoading ? <Loader/> : null}
      </button>
    );
  },

  showModal() {
    return this.loadStatus({showModal: true});
  },

  hideModal() {
    return this.setState({showModal: false});
  },

  renderInfoRow() {
    return (
      <Alert bsStyle="warning">
        <span>
          <h3 className="text-center">This extractor has been deprecated</h3>
          <span>
            {this.getInfo()}
          </span>
          <br/>
          <br/>
        </span>
        <div className="row component-empty-state text-center">
          {this.renderMigrationButton()}
        </div>
      </Alert>
    );
  },

  getInfo() {
    if (this.props.componentId === 'ex-db') {
      return 'Migrate your current configurations to new vendor specific database extractors (MySql, Postgres, Oracle, Microsoft Sql). This extractor will continue to work until August 2016. Then, all your configurations will be migrated automatically. Migration will also alter your orchestrations to use the new extractors. The old configurations will remain intact for now. You can remove it yourself after successful migration.';
    } else if (this.props.componentId === 'ex-google-analytics') {
      return 'Migrate your current configurations to new Google Analytics Extractor, which uses the newest API V4. This extractor will continue to work until November 2016. Then, all your configurations will be migrated automatically. Migration will also alter your orchestrations to use the new extractors. The old configurations will remain intact for now. You can remove it yourself after successful migration.';
    } else if (this.props.componentId === 'ex-google-drive') {
      return 'Migrate your current configurations to new Google Drive Extractor. This extractor will continue to work until April 2017. Then, all your configurations will be migrated automatically. Migration will also alter your orchestrations to use the new extractors. The old configurations will remain intact for now. You can remove them yourself after successful migration.';
    } else if (['wr-db-mysql', 'wr-db-oracle', 'wr-db-redshift'].includes(this.props.componentId)) {
      return 'Migrate your current configurations to new Database Writer. This writer will continue to work until May 2017. Then, all your configurations will be migrated automatically. Migration will also alter your orchestrations to use the new writers. The old configurations will remain intact for now. You can remove them yourself after successful migration.';
    } else {
      return '';
    }
  },

  renderModal(title, body, footer, props) {
    return (
      <Modal {...props}>
        <Modal.Header closeButton>
          <Modal.Title>
            {title}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {body}
        </Modal.Body>
        <Modal.Footer>
          {footer}
        </Modal.Footer>
      </Modal>
    );
  },

  renderOrhcestrationsStatus() {
    return (
      <span>
        <Table responsive className="table table-stripped">
          <thead>
            <tr>
              <th>
                Orchestration
              </th>
              <th>
                Contains Old extractor tasks
              </th>
              <th>
                Contains New extractors tasks
              </th>
            </tr>
          </thead>
          <tbody>
            {this.state.status.get('orchestrations', List()).map((row) =>
              <tr>
                <td>
                  {this.renderOrchestrationLink(row.get('id'), row.get('name'))}
                </td>
                <td>
                  <Check isChecked={row.get('hasOld')} />
                </td>
                <td>
                  <Check isChecked={row.get('hasNew')} />
                </td>
              </tr>
             )}
          </tbody>
        </Table>
      </span>
    );
  },

  renderDialogTitle() {
    return (
      <span>
        Configuration Migration {' '}
        <RefreshIcon
          isLoading={this.state.loadingStatus}
          onClick={this.loadStatus}
        />
        {this.renderJobInfo()}
      </span>
    );
  },

  fetchLastMigrationJob(componentId) {
    const jobQuery = `params.component:${MIGRATION_COMPONENT_ID}`;
    return jobsApi.getJobsParametrized(jobQuery, 10, 0).then((result) => {
      const jobs = result ? fromJS(result) : List();
      return jobs.find((j) => j.getIn(['params', 'configData', 'parameters', 'component']) === componentId);
    }
    );
  },

  renderConfigStatus() {
    return (
      <Table responsive className="table table-stripped">
        <thead>
          <tr>
            <th>
              Configuration
            </th>
            <th>
              Config Table
            </th>
            <th> </th>
            <th>New Configuration</th>
            <th>
              Migration Status
            </th>
          </tr>
        </thead>
        <tbody>
          {this.state.status.get('configurations', List()).map((row) =>
            <tr>
              <td>
                {this.renderConfigLink(row.get('configId'), this.props.componentId, row.get('configName'))}
              </td>
              <td>
                {this.renderTableLink(row.get('tableId'))}
              </td>
              <td>
                <i className="kbc-icon-arrow-right" />
              </td>
              <td>
                {this.renderNewConfigLink(row)}
              </td>
              <td>
                {row.get('status')}
              </td>
            </tr>
           )}
        </tbody>
      </Table>
    );
  },

  renderJobInfo() {
    const {job} = this.state;
    if (!job) {
      return (
        <div>
          <small>
            Last Job: N/A
          </small>
        </div>
      );
    }

    return (
      <div>
        <small>
          <strong>Last Job: {' '}</strong>
          {date.format(job.get('createdTime'))} by {job.getIn(['token', 'description'])}
          {' '}
          <Link to="jobDetail" params={{jobId: job.get('id')}}>
            {job.get('id')}
          </Link>
          {'  '}
          <JobStatusLabel status={job.get('status')} />
        </small>
      </div>
    );
  },

  renderNewConfigLink(row) {
    const newComponentId = this.getNewComponentId(row.get('componentId'));
    const newLabel = `${row.get('componentId')} / ${row.get('configId')}`;
    const configExists = InstalledComponentsStore.getConfig(row.get('componentId'), row.get('configId'));
    if (configExists) {
      return this.renderConfigLink(row.get('configId'), newComponentId, newLabel);
    } else {
      return newLabel;
    }
  },

  getNewComponentId(componentId) {
    if (componentId.indexOf('ex-db') > -1) {
      return `ex-db-generic-${componentId}`;
    } else if (componentNameMap.has(componentId)) {
      return componentNameMap.get(componentId);
    } else {
      return `keboola.${componentId}`;
    }
  },

  renderOrchestrationLink(orchestrationId, name) {
    return (
      <Link to={'orchestrationTasks'} params={{orchestrationId: orchestrationId}}>
        {name ? name : orchestrationId}
      </Link>
    );
  },

  renderConfigLink(configId, componentId, label) {
    return (
      <ComponentConfigurationLink componentId={componentId} configId={configId}>
        {label ? label : configId}
      </ComponentConfigurationLink>
    );
  },

  renderTableLink(tableId) {
    return (
      <SapiTableLink
        tableId={tableId}>
        {tableId}
      </SapiTableLink>);
  },

  onMigrate() {
    this.setState({isLoading: true});
    const params = {
      method: 'run',
      component: MIGRATION_COMPONENT_ID,
      data: {
        configData: {
          parameters: {
            component: this.props.componentId
          }
        }
      },
      notify: true
    };

    InstalledComponentsActionCreators
      .runComponent(params)
      .then(this.handleStarted)
      .catch((error) => {
        this.setState({isLoading: false});
        throw error;
      });
  },

  handleStarted() {
    this.setState({isLoading: false});
  }

});
