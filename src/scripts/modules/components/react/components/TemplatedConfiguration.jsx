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

      config: InstalledComponentsStore.getTemplatedConfigValueConfig(componentId, configId),
      params: InstalledComponentsStore.getTemplatedConfigValueParams(componentId, configId),
      paramsSchema: SchemasStore.getParamsSchema(componentId),
      pureParamsSchema: SchemasStore.getPureParamsSchema(componentId),
      configTemplates: SchemasStore.getConfigTemplates(componentId),
      supportsEncryption: component.get('flags').includes('encrypt'),

      isEditing: InstalledComponentsStore.isEditingTemplatedConfig(componentId, configId),
      isSaving: InstalledComponentsStore.isSavingConfigData(componentId, configId),
      isEditingString: InstalledComponentsStore.isTemplatedConfigEditingString(componentId, configId),

      editingConfig: InstalledComponentsStore.getTemplatedConfigEditingValue(componentId, configId),
      editingJobs: InstalledComponentsStore.getTemplatedConfigEditingValueJobs(componentId, configId),
      editingMappings: InstalledComponentsStore.getTemplatedConfigEditingValueJobs(componentId, configId),
      editingJobsString: InstalledComponentsStore.getTemplatedConfigEditingValueJobsString(componentId, configId),
      editingMappingsString: InstalledComponentsStore.getTemplatedConfigEditingValueMappingsString(componentId, configId),
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
          config={this.state.config}
          params={this.state.params}
          paramsSchema={this.state.paramsSchema}
          templates={this.state.configTemplates}
          onEditStart={this.onEditStart}
          editLabel={this.props.editLabel}
          />
      );
    }
  },

  renderEditor() {
    return (
      <Edit
        config={this.state.editingConfig}
        jobsString={this.state.editingJobsString}
        mappingsString={this.state.editingMappingsString}
        templates={this.state.configTemplates}
        params={this.state.editingParams}
        paramsSchema={this.state.pureParamsSchema}
        isEditingString={this.state.isEditingString}
        isSaving={this.state.isSaving}
        onSave={this.onEditSubmit}
        onChangeTemplate={this.onEditChangeTemplate}
        onChangeJobsString={this.onEditChangeJobsString}
        onChangeMappingsString={this.onEditChangeMappingsString}
        onChangeParams={this.onEditChangeParams}
        onChangeEditingMode={this.onEditChangeEditingMode}
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

  onEditChangeTemplate(value) {
    InstalledComponentsActionCreators.updateEditTemplatedComponentConfigData(this.state.componentId, this.state.configId, value);
  },

  onEditChangeJobsString(value) {
    InstalledComponentsActionCreators.updateEditTemplatedComponentConfigDataJobsString(this.state.componentId, this.state.configId, value);
  },

  onEditChangeMappingsString(value) {
    InstalledComponentsActionCreators.updateEditTemplatedComponentConfigDataMappingsString(this.state.componentId, this.state.configId, value);
  },


  onEditChangeParams(value) {
    InstalledComponentsActionCreators.updateEditTemplatedComponentConfigDataParams(this.state.componentId, this.state.configId, value);
  },

  onEditChangeEditingMode() {
    InstalledComponentsActionCreators.toggleEditTemplatedComponentConfigDataString(this.state.componentId, this.state.configId);
  },

  isValid() {
    return this.isValidJobsString() && this.isValidMappingsString();
  },

  isValidJobsString() {
    if (this.state.editingJobsString) {
      try {
        JSON.parse(this.state.editingJobsString);
        return true;
      } catch (e) {
        return false;
      }
    }
    return true;
  },

  isValidMappingsString() {
    if (this.state.editingMappingsString) {
      try {
        JSON.parse(this.state.editingMappingsString);
        return true;
      } catch (e) {
        return false;
      }
    }
    return true;
  }
});
