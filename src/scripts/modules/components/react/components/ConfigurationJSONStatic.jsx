import React, {PropTypes} from 'react';
import JSONSchemaEditor from './JSONSchemaEditor';
import SchemasStore from '../../stores/SchemasStore';
import RoutesStore from '../../../../stores/RoutesStore';
import Immutable from 'immutable';
import propagateApiAttributes from './jsoneditor/propagateApiAttributes';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';

/* global require */
require('./configuration-json.less');

export default React.createClass({

  mixins: [createStoreMixin(SchemasStore)],

  getStateFromStores() {
    var componentId = RoutesStore.getCurrentRouteParam('component');
    return {
      paramsSchema: SchemasStore.getParamsSchema(componentId).toJSON(),
      apiSchema: SchemasStore.getApiSchema(componentId).toJSON(),
      apiTemplate: SchemasStore.getApiTemplate(componentId).toJSON()
    };
  },

  propTypes: {
    data: PropTypes.string.isRequired,
    onEditStart: PropTypes.func.isRequired,
    editLabel: PropTypes.string
  },

  getDefaultProps() {
    return {
      editLabel: 'Edit configuration'
    };
  },

  render() {
    return this.extractConfigValue() || this.extractApiValue() ? this.static() : this.emptyState();
  },

  static() {
    return (
      <div className="kbc-configuration-json-edit">
        <div>
          <div className="edit kbc-configuration-editor">
            <div className="kbc-sticky-buttons">
              {this.startEditButton()}
            </div>
            {this.apiEditor()}
            <JSONSchemaEditor
              schema={this.prepareParamsSchema()}
              value={this.extractConfigValue()}
              onChange={this.handleChange}
              readOnly={true}
            />
          </div>
        </div>
      </div>
    );
  },

  emptyState() {
    return (
      <p>
        <small>No configuration.</small> {this.startEditButton()}
      </p>
    );
  },

  apiEditor() {
    if (this.requiresApiSchema()) {
      return (
        <JSONSchemaEditor
          schema={Immutable.fromJS(this.state.apiSchema)}
          value={this.extractApiValue()}
          onChange={this.handleChange}
          readOnly={true}
          />
      );
    } else {
      return null;
    }
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil"></span> {this.props.editLabel}
      </button>
    );
  },

  extractConfigValue() {
    var value;
    var parsed = JSON.parse(this.props.data);
    if (parsed.config) {
      value = parsed.config;
    }
    return value;
  },

  requiresApiSchema() {
    return Object.keys(this.state.apiTemplate).length === 0;
  },

  extractApiValue() {
    var value;
    var parsed = JSON.parse(this.props.data);
    if (parsed.api) {
      value = parsed.api;
    }
    return value;
  },

  handleChange() {
    // nothing
  },

  prepareParamsSchema() {
    if (!this.requiresApiSchema()) {
      return Immutable.fromJS(this.state.paramsSchema);
    } else {
      return propagateApiAttributes(this.extractApiValue(), Immutable.fromJS(this.state.paramsSchema));
    }
  }

});
