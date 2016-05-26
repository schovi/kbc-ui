import React from 'react';
import {Table} from 'react-bootstrap';
import {RefreshIcon} from 'kbc-react-components';
import {fromJS, List} from 'immutable';
import {Link} from 'react-router';
import SapiTableLink from './StorageApiTableLink';
import ApplicationStore from '../../../../stores/ApplicationStore';
import InstalledComponentsActionCreators from '../../InstalledComponentsActionCreators';
import EmptyState from './ComponentEmptyState';
import Confirm from '../../../../react/common/Confirm';
import {TabbedArea, TabPane, Alert} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';
import jobsApi from '../../../jobs/JobsApi';
import DockerActionFn from '../../DockerActionsApi';
import date from '../../../../utils/date';
import JobStatusLabel from '../../../../react/common/JobStatusLabel';
import {Check} from 'kbc-react-components';

const MIGRATION_COMPONENT_ID = 'keboola.config-migration-tool';
const MIGRATION_ALLOWED_FEATURE = 'components-migration';

export default React.createClass({
  propTypes: {
    componentId: React.PropTypes.string.isRequired
  },

  getInitialState() {
    return {
      loadingStatus: false,
      isLoading: false,
      status: null
    };
  },

  componentDidMount() {
    if (!this.state.status) {
      this.loadStatus();
    }
  },

  loadStatus() {
    this.setState({loadingStatus: true, loadingJob: true});
    const params = {
      configData: {
        parameters: {
          component: this.props.componentId
        }
      }
    };
    this.fetchLastMigrationJob(this.props.componentId).then((job) => this.setState({job: job, loadingJob: false}));
    return DockerActionFn(MIGRATION_COMPONENT_ID, 'status', params).then((status) => {
      return this.setState({
        status: fromJS(status),
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
    return ApplicationStore.hasCurrentAdminFeature(MIGRATION_ALLOWED_FEATURE);
  },

  render() {
    if (!this.canMigrate()) {
      return null;
    }

    const confirmText = (
      (this.state.status && !this.state.loadingStatus) ?
      <span>
        {this.renderJobInfo()}
        <div>
          <TabbedArea key="tabbedarea" animation={false}>

            <TabPane key="general" eventKey="general" tab="Affected Configurations">
              {this.renderConfigStatus()}
            </TabPane>
            <TabPane key="datasample" eventKey="datasample" tab="Affected Orchestrations">
              {this.renderOrhcestrationsStatus()}
            </TabPane>
          </TabbedArea>
        </div>
      </span>
    : 'Loading migration status...'
    );
    return (
      <div className="row kbc-header">
        <EmptyState>
          <Alert bsStyle="warning">
            <span>
              <strong>Configuration Migration: </strong>
              This extractor has been deprecated. Start migration job so your current configurations will be transferred to new vendor specific database extractors (MySql, Postgres, Oracle, Microsoft Sql). This extractor will continue to work until August 2016. Then, all your configurations will be migrated automatically. Migration will also alter your orchestrations to use the new extractors. The old configurations will remain intact for now. You can remove it yourself after successful migration.
            </span>
            <div>
              <Confirm
                text={confirmText}
                buttonType="success"
                buttonLabel="Migrate"
                onConfirm={this.onMigrate}
                title={this.renderDialogTitle()}>
                <button
                  type="button"
                  disabled={this.state.isLoading}
                  type="sumbit" className="btn btn-success">
                  Proceed to Migration
                  {this.state.isLoading ? <Loader/> : null}
                </button>

              </Confirm>
            </div>
          </Alert>
        </EmptyState>
      </div>
    );
  },

  renderOrhcestrationsStatus() {
    return (
      <span>
        <small>
          List of orchestrations containing tasks of either old db extractor or new db extractors. After succesfull migration there should be only new db extractor tasks.
        </small>
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
            {this.state.status.get('orchestrations').map((row) =>
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
        Configuration Migration
        <RefreshIcon
          isLoading={this.state.loadingStatus}
          onClick={this.loadStatus}
        />
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
          {this.state.status.get('configurations').map((row) =>
            <tr>
              <td>
                {this.renderConfigLink(row.get('configId'), 'ex-db', row.get('configName'))}
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
        <div className="col-xs-12">
          Last Job: N/A
        </div>
      );
    }

    return (
      <div className="col-xs-12">
        <strong>Last Job: {' '}</strong>
        <small>
          {date.format(job.get('createdTime'))} by {job.getIn(['token', 'description'])}
        </small>
        <Link to="jobDetail" params={{jobId: job.get('id')}}>
          {job.get('id')}
        </Link>
        {' '}
        <JobStatusLabel status={job.get('status')} />
      </div>
    );
  },

  renderNewConfigLink(row) {
    const newComponentId = `ex-db-generic-${row.get('componentId')}`;
    const newLabel = `${row.get('componentId')} / ${row.get('configId')}`;
    if (row.get('status') === 'success') {
      return this.renderConfigLink(row.get('configId'), newComponentId, newLabel);
    } else {
      return newLabel;
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
      <Link to={componentId} params={{config: configId}}>
        {label ? label : configId}
      </Link>
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
