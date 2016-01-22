import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import Sticky from 'react-sticky';
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
    isSaving: PropTypes.bool.isRequired,
    isValid: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired,
    saveLabel: PropTypes.string
  },

  getDefaultProps() {
    return {
      saveLabel: 'Save configuration'
    };
  },

  render() {
    return (
      <div className="kbc-configuration-json-edit">
        <div>
          <div className="edit kbc-configuration-editor">
            <Sticky stickyClass="kbc-sticky-buttons-active" className="kbc-sticky-buttons" topOffset={-60} stickyStyle={{}}>
              <ConfirmButtons
                isSaving={this.props.isSaving}
                onSave={this.props.onSave}
                onCancel={this.props.onCancel}
                placement="right"
                saveLabel={this.props.saveLabel}
                isDisabled={!this.props.isValid}
                />
            </Sticky>
            {this.apiEditor()}
            <JSONSchemaEditor
              schema={this.prepareParamsSchema()}
              value={this.extractConfigValue()}
              onChange={this.handleConfigChange}
              readOnly={this.props.isSaving}
            />
          </div>
        </div>
      </div>
    );
  },

  apiEditor() {
    if (this.requiresApiSchema()) {
      return (
        <JSONSchemaEditor
          schema={Immutable.fromJS(this.state.apiSchema)}
          value={this.extractApiValue()}
          onChange={this.handleApiChange}
          readOnly={this.props.isSaving}
          />
      );
    } else {
      return null;
    }
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

  prepareParamsSchema() {
    if (!this.requiresApiSchema()) {
      return Immutable.fromJS(this.state.paramsSchema);
    } else {
      return propagateApiAttributes(this.extractApiValue(), Immutable.fromJS(this.state.paramsSchema));
    }
  },

  handleConfigChange(value) {
    var config = {};
    if (this.requiresApiSchema()) {
      config = {
        api: this.extractApiValue(),
        config: value
      };
    } else {
      config = {
        api: this.state.apiTemplate,
        config: value
      };
    }
    this.props.onChange(JSON.stringify(config));
  },

  handleApiChange(value) {
    var config = {
      api: value,
      config: this.extractConfigValue()
    };
    this.props.onChange(JSON.stringify(config));
  }
});
