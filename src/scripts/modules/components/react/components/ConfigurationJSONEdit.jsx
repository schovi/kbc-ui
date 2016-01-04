import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import Sticky from 'react-sticky';
import JSONSchemaEditor from './JSONSchemaEditor';
import SchemasStore from '../../stores/SchemasStore';
import RoutesStore from '../../../../stores/RoutesStore';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';

/* global require */
require('./configuration-json.less');

export default React.createClass({

  mixins: [createStoreMixin(SchemasStore)],

  getStateFromStores() {
    var componentId = RoutesStore.getCurrentRouteParam('component');
    return {
      paramsSchema: SchemasStore.getParamsSchema(componentId).toJSON(),
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
            <JSONSchemaEditor
              schema={this.state.paramsSchema}
              value={this.extractValue()}
              onChange={this.handleChange}
              readOnly={this.props.isSaving}
            />
          </div>
        </div>
      </div>
    );
  },

  extractValue() {
    var value;
    var parsed = JSON.parse(this.props.data);
    if (parsed.config) {
      value = parsed.config;
    } else {
      value = {};
    }
    return value;
  },

  handleChange(value) {
    var config = {
      api: this.state.apiTemplate,
      config: value
    };
    this.props.onChange(JSON.stringify(config));
  }
});
