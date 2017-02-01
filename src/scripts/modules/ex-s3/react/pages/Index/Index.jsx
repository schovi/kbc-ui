import React from 'react';

// stores
import ComponentStore from '../../../../components/stores/ComponentsStore';
import InstalledComponentsStore from '../../../../components/stores/InstalledComponentsStore';
import StorageTablesStore from '../../../../components/stores/StorageTablesStore';
import StorageBucketsStore from '../../../../components/stores/StorageBucketsStore';
import RoutesStore from '../../../../../stores/RoutesStore';
import LatestJobsStore from '../../../../jobs/stores/LatestJobsStore';
import createStoreMixin from '../../../../../react/mixins/createStoreMixin';
import storeProvisioning from '../../../storeProvisioning';

// actions
import actionsProvisioning from '../../../actionsProvisioning';

// specific components
import SettingsStatic from '../../components/SettingsStatic';
import SettingsEdit from '../../components/SettingsEdit';
import CredentialsStatic from '../../components/CredentialsStatic';
import CredentialsEdit from '../../components/CredentialsEdit';
import AdvancedStatic from '../../components/AdvancedStatic';
import AdvancedEdit from '../../components/AdvancedEdit';

// global components
import ComponentDescription from '../../../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../../../components/react/components/ComponentMetadata';
import DeleteConfigurationButton from '../../../../components/react/components/DeleteConfigurationButton';
import RunComponentButton from '../../../../components/react/components/RunComponentButton';
import LatestVersions from '../../../../components/react/components/SidebarVersionsWrapper';
import LatestJobs from '../../../../components/react/components/SidebarJobs';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';
import {TabbedArea, TabPane} from 'react-bootstrap';

// utils
import {getDefaultTable, getDefaultBucket} from '../../../utils';
import {Map, List} from 'immutable';

// css
import './Index.less';

// CONSTS
const COMPONENT_ID = 'keboola.ex-s3';

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentsStore, StorageTablesStore, StorageBucketsStore, LatestJobsStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    const component = ComponentStore.getComponent(COMPONENT_ID);
    const store = storeProvisioning(configId);
    const actions = actionsProvisioning(configId);
    return {
      component: component,
      configId: configId,
      actions: actions,
      tables: StorageTablesStore.getAll(),
      localState: store.getLocalState(),
      editingState: store.getLocalState().get('settings', Map()),
      latestJobs: LatestJobsStore.getJobs(COMPONENT_ID, configId),
      destination: store.destination,
      incremental: store.incremental,
      primaryKey: store.primaryKey,
      delimiter: store.delimiter,
      enclosure: store.enclosure,
      awsAccessKeyId: store.awsAccessKeyId,
      awsSecretAccessKey: store.awsSecretAccessKey,
      s3Bucket: store.s3Bucket,
      s3Key: store.s3Key,
      wildcard: store.wildcard
    };
  },


  renderButtons() {
    if (this.state.localState.get('isEditing')) {
      return (
        <div className="tab-edit-buttons">
          <ConfirmButtons
            isSaving={this.state.localState.get('isSaving', false)}
            onSave={this.state.actions.editSave}
            onCancel={this.state.actions.editCancel}
            placement="right"
            saveLabel="Save Settings"
              />
        </div>
      );
    } else {
      return (
        <div className="tab-edit-buttons">
          <button
            className="btn btn-link"
            onClick={this.state.actions.editStart}>
            <span className="kbc-icon-pencil"></span> Change Settings
          </button>
        </div>
      );
    }
  },

  renderSettings() {
    if (this.state.localState.get('isEditing')) {
      return (
        <TabbedArea defaultActiveEventKey={1} animation={false}>
          <TabPane tab="General" eventKey={1}>
            <SettingsEdit
              s3Bucket={this.state.editingState.get('s3Bucket', '')}
              s3Key={this.state.editingState.get('s3Key', '')}
              wildcard={this.state.editingState.get('wildcard', false)}
              destination={this.state.editingState.get('destination', getDefaultTable(this.state.configId))}
              destinationDefaultBucket={getDefaultBucket(this.state.configId)}
              destinationDefaultTable={getDefaultTable(this.state.configId)}
              incremental={this.state.editingState.get('incremental', false)}
              primaryKey={this.state.editingState.get('primaryKey', List())}
              onChange={this.state.actions.editChange}
              tables={this.state.tables}
              defaultTable={getDefaultTable(this.state.configId)}
            />
          </TabPane>
          <TabPane tab="AWS Credentials" eventKey={2}>
            <CredentialsEdit
              awsAccessKeyId={this.state.editingState.get('awsAccessKeyId', '')}
              awsSecretAccessKey={this.state.editingState.get('awsSecretAccessKey', '')}
              onChange={this.state.actions.editChange}
            />
          </TabPane>
          <TabPane tab="Advanced" eventKey={3}>
            <AdvancedEdit
              delimiter={this.state.editingState.get('delimiter', ',')}
              enclosure={this.state.editingState.get('enclosure', '"')}
              onChange={this.state.actions.editChange}
            />
          </TabPane>
        </TabbedArea>
      );
    } else {
      return (
        <TabbedArea defaultActiveEventKey={1} animation={false}>
          <TabPane tab="General" eventKey={1}>
            <SettingsStatic
              awsAccessKeyId={this.state.awsAccessKeyId}
              awsSecretAccessKey={this.state.awsSecretAccessKey}
              s3Bucket={this.state.s3Bucket}
              s3Key={this.state.s3Key}
              wildcard={this.state.wildcard}
              destination={this.state.destination}
              incremental={this.state.incremental}
              primaryKey={this.state.primaryKey}
            />
          </TabPane>
          <TabPane tab="AWS Credentials" eventKey={2}>
            <CredentialsStatic
              awsAccessKeyId={this.state.awsAccessKeyId}
              awsSecretAccessKey={this.state.awsSecretAccessKey}
            />
          </TabPane>
          <TabPane tab="Advanced" eventKey={3}>
            <AdvancedStatic
              delimiter={this.state.delimiter}
              enclosure={this.state.enclosure}
            />
          </TabPane>
        </TabbedArea>
      );
    }
  },

  render() {
    return (
      <div className="container-fluid">
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <div className="col-sm-12">
              <ComponentDescription
                componentId={COMPONENT_ID}
                configId={this.state.configId}
              />
            </div>
          </div>
          {this.renderButtons()}
          {this.renderSettings()}
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <ComponentMetadata
            componentId={COMPONENT_ID}
            configId={this.state.configId}
          />
          <ul className="nav nav-stacked">
            <li>
              <RunComponentButton
                  title="Run"
                  component={COMPONENT_ID}
                  mode="link"
                  runParams={() => ({config: this.state.configId})}
              >
                <span>You are about to run extraction.</span>
              </RunComponentButton>
            </li>
            <li>
              <DeleteConfigurationButton
                componentId={COMPONENT_ID}
                configId={this.state.configId}
              />
            </li>
          </ul>
          <LatestJobs
            jobs={this.state.latestJobs}
            limit={3}
          />
          <LatestVersions
            componentId={COMPONENT_ID}
          />
        </div>
      </div>
    );
  }
});
