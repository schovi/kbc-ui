import React from 'react';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../../stores/RoutesStore';
import ApplicationStore from '../../../../stores/ApplicationStore';
import InstalledComponentStore from '../../stores/InstalledComponentsStore';
import LatestJobsStore from '../../../jobs/stores/LatestJobsStore';

import ComponentDescription from '../components/ComponentDescription';
import ComponentMetadata from '../components/ComponentMetadata';
import RunComponentButton from '../components/RunComponentButton';
import DeleteConfigurationButton from '../components/DeleteConfigurationButton';
import LatestJobs from '../components/SidebarJobs';
import Configuration from '../components/Configuration';
import TableInputMapping from '../components/generic/TableInputMapping';
import FileInputMapping from '../components/generic/FileInputMapping';
import TableOutputMapping from '../components/generic/TableOutputMapping';
import InstalledComponentsActionCreators from '../../InstalledComponentsActionCreators';
import StorageTablesStore from '../../stores/StorageTablesStore';
import StorageBucketsStore from '../../stores/StorageBucketsStore';
import {List} from 'immutable';

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, LatestJobsStore, StorageTablesStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      componentId = RoutesStore.getCurrentRouteParam('component');

    console.log('configData', InstalledComponentStore.getConfigData(componentId, configId).toJS());

    return {
      componentId: componentId,
      configDataParameters: InstalledComponentStore.getConfigDataParameters(componentId, configId),
      configData: InstalledComponentStore.getConfigData(componentId, configId),
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
      openMappings: InstalledComponentStore.getOpenMappings(componentId, configId)
    };
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
              <TableInputMapping
                componentId={this.state.componentId}
                configId={this.state.config.get('id')}
                value={this.state.configData.getIn(['storage', 'input', 'tables'], List())}
                editingValue={this.state.editingConfigData.getIn(['storage', 'input', 'tables'], List())}
                tables={this.state.tables}
                pendingActions={this.state.pendingActions}
                openMappings={this.state.openMappings}
                />
              <FileInputMapping
                componentId={this.state.componentId}
                configId={this.state.config.get('id')}
                value={this.state.configData.getIn(['storage', 'input', 'files'], List())}
                editingValue={this.state.editingConfigData.getIn(['storage', 'input', 'files'], List())}
                pendingActions={this.state.pendingActions}
                openMappings={this.state.openMappings}
                />
              <div>Input Mapping Files</div>
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
              <div>Output Mapping Files</div>
              <Configuration
                data={this.getConfigDataParameters()}
                isEditing={this.state.isParametersEditing}
                isSaving={this.state.isParametersSaving}
                onEditStart={this.onEditParametersStart}
                onEditCancel={this.onEditParametersCancel}
                onEditChange={this.onEditParametersChange}
                onEditSubmit={this.onEditParametersSubmit}
                isValid={this.state.isValidEditingConfigDataParameters}
                />
            </div>
          </div>
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <div classNmae="kbc-buttons kbc-text-light">
            <ComponentMetadata
              componentId={this.state.componentId}
              configId={this.state.config.get('id')}
              />
          </div>
          <ul className="nav nav-stacked">
            <li>
              <RunComponentButton
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
          <LatestJobs jobs={this.state.latestJobs} />
        </div>
      </div>
    );
  },

  runParams() {
    return () => ({config: this.state.config.get('id')});
  },

  contactSupport() {
    /*global Zenbox*/
    /* eslint camelcase: 0 */
    Zenbox.init({
      request_subject: 'Configuration assistance request',
      dropboxID: ApplicationStore.getKbcVars().getIn(['zendesk', 'project', 'dropboxId']),
      url: ApplicationStore.getKbcVars().getIn(['zendesk', 'project', 'url'])
    });
    Zenbox.show();
  },

  getConfigDataParameters() {
    if(this.state.isParametersEditing) {
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
  }
});
