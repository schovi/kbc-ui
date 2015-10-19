import React from 'react';
import {List} from 'immutable';
import createStoreMixin from '../../../react/mixins/createStoreMixin';
import InstalledComponentsStore from '../../components/stores/InstalledComponentsStore';
import RoutesStore from '../../../stores/RoutesStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';
import StorageTablesStore from '../../components/stores/StorageTablesStore';

import TableInputMapping from '../../components/react/components/generic/TableInputMapping';
import ComponentDescription from '../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../components/react/components/ComponentMetadata';
import RunComponentButton from '../../components/react/components/RunComponentButton';
import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';
import LatestJobs from '../../components/react/components/SidebarJobs';

const componentId = 'custom-science';


export default React.createClass({

  mixins: [createStoreMixin(InstalledComponentsStore, LatestJobsStore, StorageTablesStore)],

  getStateFromStores(){
    const configId = RoutesStore.getCurrentRouteParam('config');
    const configData = InstalledComponentsStore.getConfigData(componentId, configId);
    const localState = InstalledComponentsStore.getLocalState(componentId, configId);
    const editingConfigData = InstalledComponentsStore.getEditingConfigDataObject(componentId, configId);

    return {
      configId: configId,
      localState: localState,
      configData: configData,
      latestJobs: LatestJobsStore.getJobs(componentId, configId),
      pendingActions: InstalledComponentsStore.getPendingActions(componentId, configId),
      openMappings: InstalledComponentsStore.getOpenMappings(componentId, configId),
      tables: StorageTablesStore.getAll(),
      editingConfigData: editingConfigData
    };
  },

  render(){
    return (
      <div className="container-fluid">
        {this.renderMainContent()}
        {this.renderSidebar()}
      </div>

    );
  },

  renderMainContent(){
    return (
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <ComponentDescription
              componentId={componentId}
              configId={this.state.configId}
              />
          </div>
          <div className="row">
            <TableInputMapping
              componentId={componentId}
              tables={this.state.tables}
              pendingActions={this.state.pendingActions}
              openMappings={this.state.openMappings}
              editingValue={this.state.editingConfigData.getIn(['storage', 'input', 'tables'], List())}
              configId={this.state.configId}
              value={this.state.configData.getIn(['storage', 'input', 'tables'], List())}/>
          </div>
        </div>
    );

  },

  renderSidebar(){
    return (
        <div className="col-md-3 kbc-main-sidebar">
          <div classNmae="kbc-buttons kbc-text-light">
            <ComponentMetadata
              componentId={componentId}
              configId={this.state.configId}
              />
          </div>
          <ul className="nav nav-stacked">
            <li>
              <RunComponentButton
                title="Run"
                component={componentId}
                mode="link"
                runParams={() => ({config: this.state.configId})}
                >
                You are about to run component.
              </RunComponentButton>
            </li>
            <li>
              <DeleteConfigurationButton
                componentId={componentId}
                configId={this.state.configId}
                />
            </li>
          </ul>
          <LatestJobs jobs={this.state.latestJobs} />
        </div>
      );

  }

  /* updateLocalState(path, data){
     updateLocalState(this.state.configId, path, data);
     } */

});
