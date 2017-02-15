import React from 'react';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../../stores/RoutesStore';
import InstalledComponentStore from '../../stores/InstalledComponentsStore';
import ComponentStore from '../../stores/ComponentsStore';
import LatestJobsStore from '../../../jobs/stores/LatestJobsStore';
import ApplicationStore from '../../../../stores/ApplicationStore';
import VersionsStore from '../../stores/VersionsStore';

import Tooltip from '../../../../react/common/Tooltip';
import ComponentDescription from '../components/ComponentDescription';
import ComponentMetadata from '../components/ComponentMetadata';
import LastUpdateInfo from '../../../../react/common/LastUpdateInfo';
import RunComponentButton from '../components/RunComponentButton';
import DeleteConfigurationButton from '../components/DeleteConfigurationButton';
import LatestJobs from '../components/SidebarJobs';
import Configuration from '../components/Configuration';
import InstalledComponentsActionCreators from '../../InstalledComponentsActionCreators';
import Immutable from 'immutable';
import LatestVersions from '../components/SidebarVersionsWrapper';


export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, LatestJobsStore, ComponentStore, VersionsStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      componentId = RoutesStore.getCurrentRouteParam('component'),
      token = ApplicationStore.getSapiTokenString();

    return {
      component: ComponentStore.getComponent(componentId),
      componentId: componentId,
      versions: VersionsStore.getVersions(componentId, configId),
      configData: InstalledComponentStore.getConfigData(componentId, configId),
      config: InstalledComponentStore.getConfig(componentId, configId),
      latestJobs: LatestJobsStore.getJobs(componentId, configId),
      isEditing: InstalledComponentStore.isEditingRawConfigData(componentId, configId),
      isSaving: InstalledComponentStore.isSavingConfigData(componentId, configId),
      editingConfigData: InstalledComponentStore.getEditingRawConfigData(componentId, configId, '{}'),
      isValidEditingConfigData: InstalledComponentStore.isValidEditingConfigData(componentId, configId),
      token: token
    };
  },

  documentationLink() {
    if (this.state.component.get('documentationUrl')) {
      return (
        <span>
          See the <a href={this.state.component.get('documentationUrl')}>documentation</a> for more details about this configuration.
        </span>
      );
    } else {
      return null;
    }
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
              {this.renderConfigurationHint()}
              <Configuration
                data={this.getConfigData()}
                isEditing={this.state.isEditing}
                isSaving={this.state.isSaving}
                onEditStart={this.onEditStart}
                onEditCancel={this.onEditCancel}
                onEditChange={this.onEditChange}
                onEditSubmit={this.onEditSubmit}
                isValid={this.state.isValidEditingConfigData}
                supportsEncryption={this.state.component.get('flags').contains('encrypt')}
                showDocumentationLink={!this.state.component.get('flags').contains('genericDockerUI-runtime')}
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
            <LastUpdateInfo lastVersion={this.state.versions.get(0)} />
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
            {this.renderShinyAppLink()}
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

  renderShinyAppLink() {
    const isShiny = this.state.component.get('flags').includes('genericShinyUI');

    if (isShiny) {
      const url = this.state.configData.get('url');
      const disabledClassName = url ? '' : 'disabled';
      const tooltip = url ? 'Visit shiny app' : 'No url specified';
      const label = (<span className="kbc-sapi-table-link"><i className="fa fa-fw fa-bar-chart" /> Shiny App</span>);
      return (
        <li className={disabledClassName}>
          <Tooltip tooltip={tooltip} placement="top">
            <form action={url} method="POST" target="_blank" >
              <input type="hidden" name="token" value={this.state.token}/>
              <button disabled={!url} className="btn btn-link" type="submit">
                {label}
              </button>
            </form>
          </Tooltip>
        </li>
      );
    } else {
      return false;
    }
  },

  runParams() {
    return () => ({config: this.state.config.get('id')});
  },

  getConfigData() {
    if (this.state.isEditing) {
      return this.state.editingConfigData;
    } else {
      return JSON.stringify(this.state.configData.toJSON(), null, '  ');
    }
  },

  onEditStart() {
    InstalledComponentsActionCreators.startEditComponentRawConfigData(this.state.componentId, this.state.config.get('id'));
  },

  onEditCancel() {
    InstalledComponentsActionCreators.cancelEditComponentRawConfigData(this.state.componentId, this.state.config.get('id'));
  },

  onEditChange(newValue) {
    InstalledComponentsActionCreators.updateEditComponentRawConfigData(this.state.componentId, this.state.config.get('id'), newValue);
  },

  onEditSubmit() {
    InstalledComponentsActionCreators.saveComponentRawConfigData(this.state.componentId, this.state.config.get('id'));
  },

  isTemplatedComponent() {
    return this.state.component.get('flags', Immutable.List()).includes('genericTemplatesUI');
  },

  renderConfigurationHint() {
    if (!this.isTemplatedComponent()) {
      return (<p className="help-block">This component has to be configured manually. {this.documentationLink()} </p>);
    }
    return null;
  }

});
