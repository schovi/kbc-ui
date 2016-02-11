import React, {PropTypes} from 'react';
import Edit from './TemplatedConfigurationEdit';
import Static from './TemplatedConfigurationStatic';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../../stores/RoutesStore';
import InstalledComponentStore from '../../stores/InstalledComponentsStore';
import ComponentStore from '../../stores/ComponentsStore';
import SchemasStore from '../../stores/SchemasStore';

/* global require */
require('codemirror/mode/javascript/javascript');

export default React.createClass({
  mixins: [createStoreMixin(RoutesStore, InstalledComponentStore, ComponentStore, SchemasStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      componentId = RoutesStore.getCurrentRouteParam('component'),
      component = ComponentStore.getComponent(componentId);

    return {
      jobs: InstalledComponentStore.getTemplatedConfigValueJobs(componentId, configId),
      params: InstalledComponentStore.getTemplatedConfigValueParams(componentId, configId),
      api: InstalledComponentStore.getTemplatedConfigValueApi(componentId, configId),
      paramsSchema: SchemasStore.getParamsSchema(componentId),
      pureParamsSchema: SchemasStore.getPureParamsSchema(componentId),
      jobsTemplates: SchemasStore.getJobsTemplates(componentId),
      apiSchema: SchemasStore.getApiSchema(componentId),
      apiTemplate: SchemasStore.getApiTemplate(componentId),
      supportsEncryption: component.get('flags').includes('encrypt'),
      isEditing: false
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
      return (
        <span>
          {
            this.state.supportsEncryption ?
              <p className="help-block small">Properties prefixed with <code>#</code> sign will be encrypted on save. Already encrypted strings will persist.</p>
              : null
          }
          { this.renderEditor() }
        </span>
      );
    } else {
      return (
        <Static
          jobs={this.state.jobs}
          params={this.state.params}
          api={this.state.api}
          paramsSchema={this.state.paramsSchema}
          jobsTemplates={this.state.jobsTemplates}
          apiSchema={this.state.apiSchema}
          apiTemplate={this.state.apiTemplate}
          requiresApiSchema={this.state.apiTemplate.count() === 0}
          onEditStart={this.onEditStart}
          editLabel={this.props.editLabel}
          />
      );
    }
  },

  renderEditor() {
    return (
      <Edit
        // data={this.props.data}
        isSaving={this.state.isSaving}
        onSave={this.onEditSubmit}
        onChange={this.onEditChange}
        onCancel={this.onEditCancel}
        isValid={this.state.isValid}
        saveLabel={this.props.saveLabel}
        />
    );
  }
});
