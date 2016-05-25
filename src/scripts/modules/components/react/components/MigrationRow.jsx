import React from 'react';
import {Table} from 'react-bootstrap';
import {RefreshIcon} from 'kbc-react-components';
import {fromJS} from 'immutable';
import {Link} from 'react-router';
import SapiTableLink from './StorageApiTableLink';
import ApplicationStore from '../../../../stores/ApplicationStore';
import InstalledComponentsActionCreators from '../../InstalledComponentsActionCreators';
import EmptyState from './ComponentEmptyState';
import Confirm from '../../../../react/common/Confirm';
import {Alert} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';
import DockerActionFn from '../../DockerActionsApi';

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
    this.setState({loadingStatus: true});
    const params = {
      configData: {
        parameters: {
          component: this.props.componentId
        }
      }
    };
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
      <span>
        <div>
          This will initiate a migration procces which can be then tracked in the jobs section. Nothing will be removed and the current configurations will remain untouched.
        </div>
        <div>
          <div>
            TODO: LAST JOB STATUS, creator, link to job
          </div>
          Migration Info:{' '}
          <RefreshIcon
            isLoading={this.state.loadingStatus}
            onClick={this.loadStatus}
          />

          <span>
            {this.renderStatus()}
          </span>
        </div>
      </span>
    );
    return (
      <div className="row kbc-header">
        <EmptyState>
          <Alert bsStyle="warning">
            <span>
              This is a deprecated component, we have prepared new  components,
              click on the button and initiate a migration process
              of all configurations to the new component of database extractor
            </span>
            <div>
              <Confirm
                text={confirmText}
                buttonType="success"
                buttonLabel="Migrate"
                onConfirm={this.onMigrate}
                title="Migration Configuration">
                <button
                  type="button"
                  disabled={this.state.isLoading}
                  type="sumbit" className="btn btn-success">
                  Migrate
                  {this.state.isLoading ? <Loader/> : null}
                </button>

              </Confirm>
            </div>
          </Alert>
        </EmptyState>
      </div>
    );
  },

  getNewComponentId(row) {
    const componentId = row.get('componentId');
    return `ex-db-generic-${componentId}`;
  },

  renderStatus() {
    if (!this.state.status) {return null;}
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
          {this.state.status.map((row) =>
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
                {this.renderConfigLink(row.get('configId'), this.getNewComponentId(row), `${row.get('componentId')}/${row.get('configId')}`)}
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
