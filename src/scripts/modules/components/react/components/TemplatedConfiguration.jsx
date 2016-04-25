import React, {PropTypes} from 'react';
import Edit from './TemplatedConfigurationEdit';
import Static from './TemplatedConfigurationStatic';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../../stores/RoutesStore';
import InstalledComponentsStore from '../../stores/InstalledComponentsStore';
import ComponentStore from '../../stores/ComponentsStore';
import SchemasStore from '../../stores/SchemasStore';

import InstalledComponentsActionCreators from '../../InstalledComponentsActionCreators';

/* global require */
require('codemirror/mode/javascript/javascript');

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentsStore, ComponentStore, SchemasStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      componentId = RoutesStore.getCurrentRouteParam('component'),
      component = ComponentStore.getComponent(componentId);

    return {
      componentId: componentId,
      configId: configId,

      jobs: InstalledComponentsStore.getTemplatedConfigValueJobs(componentId, configId),
      params: InstalledComponentsStore.getTemplatedConfigValueParams(componentId, configId),
      paramsSchema: SchemasStore.getParamsSchema(componentId),
      pureParamsSchema: SchemasStore.getPureParamsSchema(componentId),
      jobsTemplates: SchemasStore.getJobsTemplates(componentId),
      supportsEncryption: component.get('flags').includes('encrypt'),

      isEditing: InstalledComponentsStore.isEditingTemplatedConfig(componentId, configId),
      isSaving: InstalledComponentsStore.isSavingConfigData(componentId, configId),
      isEditingJobsString: InstalledComponentsStore.isTemplatedConfigEditingJobsString(componentId, configId),

      editingJobs: InstalledComponentsStore.getTemplatedConfigEditingValueJobs(componentId, configId),
      editingJobsString: InstalledComponentsStore.getTemplatedConfigEditingValueJobsString(componentId, configId),
      editingParams: InstalledComponentsStore.getTemplatedConfigEditingValueParams(componentId, configId)

    };
  },

  propTypes: {
    headerText: PropTypes.string,
    editLabel: PropTypes.string,
    saveLabel: PropTypes.string,
    help: PropTypes.node
  },

  getDefaultProps() {
    return {
      headerText: 'Configuration Data',
      help: null,
      editLabel: 'Edit configuration',
      saveLabel: 'Save configuration'
    };
  },

  render() {
    return (
      <div>
        <h2>{this.props.headerText}</h2>
        {this.props.help}
        {this.scripts()}
      </div>
    );
  },

  scripts() {
    if (this.state.isEditing) {
      return this.renderEditor();
    } else {
      return (
        <Static
          jobs={this.state.jobs}
          params={this.state.params}
          paramsSchema={this.state.paramsSchema}
          jobsTemplates={this.state.jobsTemplates}
          onEditStart={this.onEditStart}
          editLabel={this.props.editLabel}
          />
      );
    }
  },

  renderEditor() {
    return (
      <Edit
        jobs={this.state.editingJobs}
        jobsString={this.state.editingJobsString}
        jobsTemplates={this.state.jobsTemplates}
        params={this.state.editingParams}
        paramsSchema={this.state.pureParamsSchema}
        isEditingJobsString={this.state.isEditingJobsString}
        isSaving={this.state.isSaving}
        onSave={this.onEditSubmit}
        onChangeJobs={this.onEditChangeJobs}
        onChangeJobsString={this.onEditChangeJobsString}
        onChangeParams={this.onEditChangeParams}
        onChangeJobsEditingMode={this.onEditChangeJobsEditingMode}
        onCancel={this.onEditCancel}
        isValid={this.isValid()}
        saveLabel={this.props.saveLabel}
        />
    );
  },

  onEditStart() {
    InstalledComponentsActionCreators.startEditTemplatedComponentConfigData(this.state.componentId, this.state.configId);
  },

  onEditCancel() {
    InstalledComponentsActionCreators.cancelEditTemplatedComponentConfigData(this.state.componentId, this.state.configId);
  },

  onEditSubmit() {
    InstalledComponentsActionCreators.saveEditTemplatedComponentConfigData(this.state.componentId, this.state.configId);
  },

  onEditChangeJobs(value) {
    InstalledComponentsActionCreators.updateEditTemplatedComponentConfigDataJobs(this.state.componentId, this.state.configId, value);
  },

  onEditChangeJobsString(value) {
    InstalledComponentsActionCreators.updateEditTemplatedComponentConfigDataJobsString(this.state.componentId, this.state.configId, value);
  },

  onEditChangeParams(value) {
    InstalledComponentsActionCreators.updateEditTemplatedComponentConfigDataParams(this.state.componentId, this.state.configId, value);
  },

  onEditChangeJobsEditingMode() {
    InstalledComponentsActionCreators.toggleEditTemplatedComponentConfigDataJobsString(this.state.componentId, this.state.configId);
  },

  isValid() {
    if (this.state.editingJobsString) {
      try {
        JSON.parse(this.state.editingJobsString);
        return true;
      } catch (e) {
        return false;
      }
    }
    return true;
  }
});
