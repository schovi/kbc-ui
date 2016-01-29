import React, {PropTypes} from 'react';
import JSONSchemaEditor from './JSONSchemaEditor';
import SchemasStore from '../../stores/SchemasStore';
import RoutesStore from '../../../../stores/RoutesStore';
import Immutable from 'immutable';
import Markdown from 'react-markdown';

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
      pureParamsSchema: SchemasStore.getPureParamsSchema(componentId).toJSON(),
      jobsTemplates: SchemasStore.getJobsTemplates(componentId),
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

  jobsValue: Immutable.List(),
  paramsValue: Immutable.Map(),
  apiValue: Immutable.Map(),

  componentDidMount() {
    var parsed = JSON.parse(this.props.data);

    if (parsed.config) {
      this.paramsValue = Immutable.fromJS(parsed.config).delete('jobs');
    } else {
      this.paramsValue = Immutable.Map();
    }

    if (parsed.config && parsed.config.jobs) {
      this.jobsValue = Immutable.fromJS(parsed.config.jobs);
    } else {
      this.jobsValue = Immutable.List();
    }

    if (this.requiresApiSchema()) {
      if (parsed.api) {
        this.apiValue = Immutable.fromJS(parsed.api);
      } else {
        this.apiValue = Immutable.Map();
      }
    } else {
      this.apiValue = Immutable.fromJS(this.state.apiTemplate);
    }
  },

  render() {
    if (this.requiresApiSchema()) {
      return !this.paramsValue.isEmpty() || !this.apiValue.isEmpty() || !this.jobsValue.isEmpty() ? this.static() : this.emptyState();
    } else {
      return !this.paramsValue.isEmpty() || !this.jobsValue.isEmpty() ? this.static() : this.emptyState();
    }
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
              value={this.paramsValue.toJS()}
              onChange={this.handleChange}
              readOnly={true}
            />
            {this.renderJobs()}
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

  getTemplate(hashCode) {
    return this.state.jobsTemplates.filter(
      function(template) {
        return template.get('jobs').hashCode() === parseInt(hashCode, 10);
      }
    ).first();
  },

  renderJobs() {
    var template = this.getTemplate(this.jobsValue.hashCode());
    if (template) {
      return (
        <span>
          <h3>{template.get('name')}</h3>
          <Markdown
            source={template.get('description')}
            />
        </span>
      );
    }
  },

  apiEditor() {
    if (this.requiresApiSchema()) {
      return (
        <JSONSchemaEditor
          schema={Immutable.fromJS(this.state.apiSchema)}
          value={this.apiValue.toJS()}
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

  requiresApiSchema() {
    return Object.keys(this.state.apiTemplate).length === 0;
  },

  handleChange() {
    // nothing
  },

  prepareParamsSchema() {
    if (!this.requiresApiSchema()) {
      return Immutable.fromJS(this.state.pureParamsSchema);
    } else {
      return propagateApiAttributes(this.apiValue, Immutable.fromJS(this.state.paramsSchema));
    }
  }

});
