import React from 'react';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../../stores/RoutesStore';
import InstalledComponentStore from '../../stores/InstalledComponentsStore';
import LatestJobsStore from '../../../jobs/stores/LatestJobsStore';
import ComponentStore from '../../stores/ComponentsStore';
import VersionsStore from '../../stores/VersionsStore';

import * as oauthUtils from '../../../oauth-v2/OauthUtils';
import OauthStore from '../../../oauth-v2/Store';

import ComponentDescription from '../components/ComponentDescription';
import ComponentMetadata from '../components/ComponentMetadata';
import RunComponentButton from '../components/RunComponentButton';
import DeleteConfigurationButton from '../components/DeleteConfigurationButton';
import LatestJobs from '../components/SidebarJobs';
import Configuration from '../components/Configuration';
import RuntimeConfiguration from '../components/RuntimeConfiguration';
import TemplatedConfiguration from '../components/TemplatedConfiguration';
import TableInputMapping from '../components/generic/TableInputMapping';
import FileInputMapping from '../components/generic/FileInputMapping';
import AuthorizationRow from '../../../oauth-v2/react/AuthorizationRow.jsx';
import TableOutputMapping from '../components/generic/TableOutputMapping';
import FileOutputMapping from '../components/generic/FileOutputMapping';
import InstalledComponentsActionCreators from '../../InstalledComponentsActionCreators';
import StorageTablesStore from '../../stores/StorageTablesStore';
import StorageBucketsStore from '../../stores/StorageBucketsStore';
import {Map, List} from 'immutable';
import contactSupport from '../../../../utils/contactSupport';
import LastUpdateInfo from '../../../../react/common/LastUpdateInfo';
import Immutable from 'immutable';
import LatestVersions from '../components/SidebarVersionsWrapper';

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, LatestJobsStore, StorageTablesStore, OauthStore, ComponentStore, VersionsStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      componentId = RoutesStore.getCurrentRouteParam('component'),
      localState = InstalledComponentStore.getLocalState(componentId, configId),
      configData = InstalledComponentStore.getConfigData(componentId, configId),
      credentialsId = oauthUtils.getCredentialsId(configData) || configId;

    return {
      componentId: componentId,
      configId: configId,
      versions: VersionsStore.getVersions(componentId, configId),
      configDataParameters: InstalledComponentStore.getConfigDataParameters(componentId, configId),
      configData: configData,
      editingConfigData: InstalledComponentStore.getEditingConfigDataObject(componentId, configId),
      config: InstalledComponentStore.getConfig(componentId, configId),
      latestJobs: LatestJobsStore.getJobs(componentId, configId),
      isParametersEditing: InstalledComponentStore.isEditingRawConfigDataParameters(componentId, configId),
      isParametersSaving: InstalledComponentStore.isSavingConfigDataParameters(componentId, configId),
      editingConfigDataParameters: InstalledComponentStore.getEditingRawConfigDataParameters(componentId, configId, '{}'),
      isValidEditingConfigDataParameters: InstalledComponentStore.isValidEditingConfigDataParameters(componentId, configId),
      tables: StorageTablesStore.getAll(),
      buckets: StorageBucketsStore.getAll(),
      pendingActions: InstalledComponentStore.getPendingActions(componentId, configId),
      openMappings: InstalledComponentStore.getOpenMappings(componentId, configId),
      component: ComponentStore.getComponent(componentId),
      localState: localState,
      credentialsId: credentialsId,
      oauthCredentials: oauthUtils.getCredentials(componentId, credentialsId)
    };
  },

  documentationLink() {
    if (this.state.component.get('documentationUrl')) {
      return (
        <span>
          See the <a href={this.state.component.get('documentationUrl')}>documentation</a> for more details.
        </span>
      );
    } else {
      return null;
    }
  },

  // handle configuration->Runtime runtime object
  runtimeConfiguration() {
    if (this.state.component.get('flags').includes('genericDockerUI-runtime')) {
      return (
        <div>
          <RuntimeConfiguration
            data={this.getConfigDataRuntime()}
            isEditing={this.state.localState.getIn(['runtime', 'isEditing'], false)}
            isSaving={this.state.localState.getIn(['runtime', 'saving'], false)}
            onEditStart={this.onEditRuntimeStart}
            onEditCancel={this.onEditRuntimeCancel}
            onEditChange={this.onEditRuntimeChange}
            headerText="Runtime"
            onEditSubmit={this.onEditRuntimeSubmit}
            isValid={this.state.isValidEditingConfigDataRuntime}
            supportsEncryption={false}
            />
        </div>
      );
    } else {
      return null;
    }
  },

  tableInputMapping() {
    if (this.state.component.get('flags').includes('genericDockerUI-tableInput')) {
      return (
        <TableInputMapping
          componentId={this.state.componentId}
          configId={this.state.config.get('id')}
          value={this.state.configData.getIn(['storage', 'input', 'tables'], List())}
          editingValue={this.state.editingConfigData.getIn(['storage', 'input', 'tables'], List())}
          tables={this.state.tables}
          pendingActions={this.state.pendingActions}
          openMappings={this.state.openMappings}
          />
      );
    } else {
      return null;
    }
  },

  fileInputMapping() {
    if (this.state.component.get('flags').includes('genericDockerUI-fileInput')) {
      return (
        <FileInputMapping
          componentId={this.state.componentId}
          configId={this.state.config.get('id')}
          value={this.state.configData.getIn(['storage', 'input', 'files'], List())}
          editingValue={this.state.editingConfigData.getIn(['storage', 'input', 'files'], List())}
          pendingActions={this.state.pendingActions}
          openMappings={this.state.openMappings}
          />
      );
    } else {
      return null;
    }
  },

  tableOutputMapping() {
    if (this.state.component.get('flags').includes('genericDockerUI-tableOutput')) {
      return (
        <TableOutputMapping
          componentId={this.state.componentId}
          configId={this.state.config.get('id')}
          value={this.state.configData.getIn(['storage', 'output', 'tables'], List())}
          editingValue={this.state.editingConfigData.getIn(['storage', 'output', 'tables'], List())}
          tables={this.state.tables}
          buckets={this.state.buckets}
          pendingActions={this.state.pendingActions}
          openMappings={this.state.openMappings}
          />
      );
    } else {
      return null;
    }
  },

  fileOutputMapping() {
    if (this.state.component.get('flags').includes('genericDockerUI-fileOutput')) {
      return (
        <FileOutputMapping
          componentId={this.state.componentId}
          configId={this.state.config.get('id')}
          value={this.state.configData.getIn(['storage', 'output', 'files'], List())}
          editingValue={this.state.editingConfigData.getIn(['storage', 'output', 'files'], List())}
          pendingActions={this.state.pendingActions}
          openMappings={this.state.openMappings}
          />
      );
    } else {
      return null;
    }
  },

  hasAuthorizeFlag() {
    return this.state.component.get('flags').includes('genericDockerUI-authorization');
  },

  accountAuthorization() {
    if (this.hasAuthorizeFlag()) {
      return (
        <AuthorizationRow
          id={this.state.credentialsId}
          configId={this.state.config.get('id')}
          componentId={this.state.componentId}
          credentials={this.state.oauthCredentials}
          isResetingCredentials={this.state.localState.get('deletingCredentials', false)}
          onResetCredentials={this.deleteCredentials}

        />
      );
    } else {
      return null;
    }
  },

  deleteCredentials() {
    this.updateLocalState(['deletingCredentials'], true);
    const componentId = this.state.componentId;
    const configId = this.state.config.get('id');
    oauthUtils.deleteCredentialsAndConfigAuth(componentId, configId).then( () => {
      this.updateLocalState(['deletingCredentials'], false);
    });
  },

  render() {
    return (
      <div className="container-fluid">
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <ComponentDescription
              componentId={this.state.componentId}
              configId={this.state.config.get('id')}
              />
          </div>
          <div className="row">
            <div classNmae="col-xs-4">
              {this.accountAuthorization()}
              {this.tableInputMapping()}
              {this.fileInputMapping()}
              {this.tableOutputMapping()}
              {this.fileOutputMapping()}
              {this.isTemplatedComponent() ? (
                <TemplatedConfiguration
                  headerText="Configuration"
                  editLabel="Edit configuration"
                  saveLabel="Save configuration"
                  />
              ) : (
                <span>
                  <Configuration
                    data={this.getConfigDataParameters()}
                    isEditing={this.state.isParametersEditing}
                    isSaving={this.state.isParametersSaving}
                    onEditStart={this.onEditParametersStart}
                    onEditCancel={this.onEditParametersCancel}
                    onEditChange={this.onEditParametersChange}
                    onEditSubmit={this.onEditParametersSubmit}
                    isValid={this.state.isValidEditingConfigDataParameters}
                    headerText="Configuration"
                    editLabel="Edit configuration"
                    saveLabel="Save configuration"
                    supportsEncryption={this.state.component.get('flags').includes('encrypt')}
                    schema={this.state.component.get('configurationSchema', Map())}
                    editHelp={this.state.component.get('configurationDescription')}
                    documentationUrl={this.state.component.get('documentationUrl')}
                    />
                </span>
              )}
              {this.runtimeConfiguration()}
            </div>

          </div>
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <div classNmae="kbc-buttons kbc-text-light">
            <ComponentMetadata
              componentId={this.state.componentId}
              configId={this.state.config.get('id')}
            />
            <LastUpdateInfo lastVersion={this.state.versions.get(0)} />
          </div>
          <ul className="nav nav-stacked">
            <li className={!!this.isRunDisabledReason() ? 'disabled' : ''}>
              <RunComponentButton
                disabled={!!this.isRunDisabledReason()}
                disabledReason={this.isRunDisabledReason()}
                title="Run"
                component={this.state.componentId}
                mode="link"
                runParams={this.runParams()}
                >
                You are about to run component.
              </RunComponentButton>
            </li>
            <li>
              <DeleteConfigurationButton
                componentId={this.state.componentId}
                configId={this.state.config.get('id')}
                />
            </li>
          </ul>
          <LatestJobs
            jobs={this.state.latestJobs}
            limit={3}
          />
          <LatestVersions
            limit={3}
          />
        </div>
      </div>
    );
  },

  runParams() {
    return () => ({config: this.state.config.get('id')});
  },

  contactSupport() {
    contactSupport({
      type: 'project',
      subject: 'Configuration assistance request'
    });
  },

  getConfigDataRuntime() {
    if (this.state.localState.getIn(['runtime', 'isEditing'])) {
      return this.state.localState.getIn(['runtime', 'editing']);
    } else {
      return this.state.configData.get('runtime', Map());
    }
  },

  onEditRuntimeStart() {
    const data = this.state.configData.get('runtime', Map());
    let runtime = this.state.localState.get('runtime', Map());
    runtime = runtime.set('editing', data);
    runtime = runtime.set('isEditing', true);
    this.updateLocalState(['runtime'], runtime);
  },

  onEditRuntimeCancel() {
    this.updateLocalState(['runtime'], Map());
  },

  onEditRuntimeChange(newValue) {
    this.updateLocalState(['runtime', 'editing'], newValue);
  },

  onEditRuntimeSubmit() {
    const newRuntime = this.state.localState.getIn(['runtime', 'editing']);
    const newConfigData = this.state.configData.set('runtime', newRuntime);
    const saveFn = InstalledComponentsActionCreators.saveComponentConfigData;
    const componentId = this.state.componentId;
    const configId = this.state.config.get('id');
    this.updateLocalState(['runtime', 'saving'], true);
    saveFn(componentId, configId, newConfigData, 'Update runtime configuration').then( () => {
      this.updateLocalState(['runtime', 'saving'], false);
      return this.onEditRuntimeCancel();
    });
  },

  getConfigDataParameters() {
    if (this.state.isParametersEditing) {
      return this.state.editingConfigDataParameters;
    } else {
      return JSON.stringify(this.state.configDataParameters.toJSON(), null, '  ');
    }
  },

  onEditParametersStart() {
    InstalledComponentsActionCreators.startEditComponentRawConfigDataParameters(this.state.componentId, this.state.config.get('id'));
  },

  onEditParametersCancel() {
    InstalledComponentsActionCreators.cancelEditComponentRawConfigDataParameters(this.state.componentId, this.state.config.get('id'));
  },

  onEditParametersChange(newValue) {
    InstalledComponentsActionCreators.updateEditComponentRawConfigDataParameters(this.state.componentId, this.state.config.get('id'), newValue);
  },

  onEditParametersSubmit() {
    InstalledComponentsActionCreators.saveComponentRawConfigDataParameters(this.state.componentId, this.state.config.get('id'));
  },

  isAuthorized() {
    const creds = this.state.oauthCredentials;
    return  creds && creds.has('id');
  },

  isRunDisabledReason() {
    if (this.hasAuthorizeFlag() && !this.isAuthorized()) {
      return 'No account authorized';
    }
    return null;
  },

  isStringValidJson(stringObject) {
    try {
      JSON.parse(stringObject);
      return true;
    } catch (e) {
      return false;
    }
  },

  updateLocalState(path, data) {
    const configId = this.state.config.get('id');
    const componentId = this.state.componentId;
    const newState = this.state.localState.setIn(path, data);
    InstalledComponentsActionCreators.updateLocalState(componentId, configId, newState, path);
  },

  isTemplatedComponent() {
    return this.state.component.get('flags', Immutable.List()).includes('genericTemplatesUI');
  }
});
