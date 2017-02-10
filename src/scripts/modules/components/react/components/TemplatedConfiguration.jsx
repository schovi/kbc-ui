import React, {PropTypes} from 'react';
import Edit from './TemplatedConfigurationEdit';
import Static from './TemplatedConfigurationStatic';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../../stores/RoutesStore';
import InstalledComponentsStore from '../../stores/InstalledComponentsStore';
import ComponentsStore from '../../stores/ComponentsStore';
import TemplatesStore from '../../stores/TemplatesStore';

import InstalledComponentsActionCreators from '../../InstalledComponentsActionCreators';

import Markdown from '../../../../react/common/Markdown';

/* global require */
require('codemirror/mode/javascript/javascript');

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentsStore, ComponentsStore, TemplatesStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      componentId = RoutesStore.getCurrentRouteParam('component'),
      component = ComponentsStore.getComponent(componentId);

    return {
      componentId: componentId,
      configId: configId,
      component: ComponentsStore.getComponent(componentId),

      config: InstalledComponentsStore.getTemplatedConfigValueConfig(componentId, configId),
      configSchema: component.get('configurationSchema'),
      configTemplates: TemplatesStore.getConfigTemplates(componentId),
      isTemplate: TemplatesStore.isConfigTemplate(
        componentId,
        InstalledComponentsStore.getTemplatedConfigValueConfig(componentId, configId)
      ) || InstalledComponentsStore.getTemplatedConfigValueWithoutUserParams(componentId, configId).isEmpty(),
      selectedTemplate: TemplatesStore.getMatchingTemplate(
        componentId,
        InstalledComponentsStore.getTemplatedConfigValueConfig(componentId, configId)
      ),
      params: InstalledComponentsStore.getTemplatedConfigValueUserParams(componentId, configId),

      supportsEncryption: component.get('flags').includes('encrypt'),

      isEditing: InstalledComponentsStore.isEditingTemplatedConfig(componentId, configId),
      isSaving: InstalledComponentsStore.isSavingConfigData(componentId, configId),
      isEditingString: InstalledComponentsStore.isTemplatedConfigEditingString(componentId, configId),

      editingParams: InstalledComponentsStore.getTemplatedConfigEditingValueParams(componentId, configId),
      editingTemplate: InstalledComponentsStore.getTemplatedConfigEditingValueTemplate(componentId, configId),
      editingString: InstalledComponentsStore.getTemplatedConfigEditingValueString(componentId, configId)

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
        {this.renderHelp()}
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
          isTemplate={this.state.isTemplate}
          template={this.state.selectedTemplate}
          params={this.state.params}
          paramsSchema={this.state.configSchema}
          onEditStart={this.onEditStart}
          editLabel={this.props.editLabel}
          />
      );
    }
  },

  renderEditor() {
    return (
      <Edit
        editingTemplate={this.state.editingTemplate}
        editingParams={this.state.editingParams}
        editingString={this.state.editingString}

        templates={this.state.configTemplates}
        paramsSchema={this.state.configSchema}
        isEditingString={this.state.isEditingString}

        isValid={this.isValid()}
        isSaving={this.state.isSaving}

        onSave={this.onEditSubmit}
        onChangeTemplate={this.onEditChangeTemplate}
        onChangeString={this.onEditChangeString}
        onChangeParams={this.onEditChangeParams}
        onChangeEditingMode={this.onEditChangeEditingMode}
        onCancel={this.onEditCancel}
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
    InstalledComponentsActionCreators.updateEditTemplatedComponentConfigDataTemplate(this.state.componentId, this.state.configId, value);
  },

  onEditChangeString(value) {
    InstalledComponentsActionCreators.updateEditTemplatedComponentConfigDataString(this.state.componentId, this.state.configId, value);
  },


  onEditChangeParams(value) {
    InstalledComponentsActionCreators.updateEditTemplatedComponentConfigDataParams(this.state.componentId, this.state.configId, value);
  },

  onEditChangeEditingMode(isStringEditingMode) {
    InstalledComponentsActionCreators.toggleEditTemplatedComponentConfigDataString(this.state.componentId, this.state.configId, isStringEditingMode);
  },

  isValid() {
    if (this.state.editingString) {
      try {
        JSON.parse(this.state.editingString);
        return true;
      } catch (e) {
        return false;
      }
    }
    return true;
  },

  renderHelp() {
    if (!this.state.component.get('configurationDescription')) {
      return null;
    }
    return (
      <Markdown
        source={this.state.component.get('configurationDescription')}
        height="small"
        />
    );
  }
});
