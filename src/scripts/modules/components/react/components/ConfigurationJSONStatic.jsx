import React, {PropTypes} from 'react';
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
      paramsSchema: SchemasStore.getParamsSchema(componentId).toJSON()
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
    return this.extractValue() ? this.static() : this.emptyState();
  },

  static() {
    return (
      <div className="kbc-configuration-json-edit">
        <div>
          <div className="edit kbc-configuration-editor">
            <div className="kbc-sticky-buttons">
              {this.startEditButton()}
            </div>
            <JSONSchemaEditor
              schema={this.state.paramsSchema}
              value={this.extractValue()}
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

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil"></span> {this.props.editLabel}
      </button>
    );
  },

  extractValue() {
    var value;
    var parsed = JSON.parse(this.props.data);
    if (parsed.config) {
      value = parsed.config;
    } else {
      return null;
    }
    return value;
  },

  handleChange() {
    // nothing
  }
});
