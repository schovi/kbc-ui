import React, {PropTypes} from 'react';
import JSONSchemaEditor from './JSONSchemaEditor';
import Markdown from 'react-markdown';
import CodeMirror from 'react-code-mirror';
import getTemplatedConfigHashCode from '../../utils/getTemplatedConfigHashCode';
import Immutable from 'immutable';

/* global require */
require('./configuration-json.less');

export default React.createClass({

  propTypes: {
    config: PropTypes.object.isRequired,
    params: PropTypes.object.isRequired,
    paramsSchema: PropTypes.object.isRequired,
    templates: PropTypes.object.isRequired,
    onEditStart: PropTypes.func,
    editLabel: PropTypes.string
  },

  getDefaultProps() {
    return {
      editLabel: 'Edit configuration'
    };
  },

  render() {
    return !this.props.params.isEmpty() ||
      !this.props.config.get('jobs', Immutable.List()) ||
      !this.props.config.get('mappings', Immutable.Map()).isEmpty() ? this.static() : this.emptyState();
  },

  renderJSONSchemaEditor() {
    // empty json schema does not render
    if (!this.props.paramsSchema.get('properties') || this.props.paramsSchema.get('properties').count() === 0) {
      return null;
    }
    return (
      <JSONSchemaEditor
        schema={this.props.paramsSchema}
        value={this.props.params}
        onChange={this.handleChange}
        readOnly={true}
      />
    );
  },

  static() {
    return (
      <div>
        <div className="edit kbc-configuration-editor">
          <div className="text-right">{this.startEditButton()}</div>
          {this.renderJSONSchemaEditor()}
          {this.renderConfig()}
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
    return this.props.templates.filter(
      function(template) {
        return getTemplatedConfigHashCode(template) === parseInt(hashCode, 10);
      }
    ).first();
  },

  renderConfig() {
    var template = this.getTemplate(getTemplatedConfigHashCode(this.props.config));
    if (!template && this.props.config.get('jobs', Immutable.List()).count() === 0 && this.props.config.get('mappings', Immutable.Map()).count() === 0) {
      return (
        <span>
          <h3>Configuration</h3>
          <div><em>No template selected</em></div>
        </span>
      );
    } else if (!template) {
      return (
        <span>
          <h3>Endpoints</h3>
          <CodeMirror
            ref="CodeMirror"
            value={JSON.stringify(this.props.config.get('jobs', Immutable.List()).toJS(), null, 2)}
            theme="solarized"
            lineNumbers={false}
            mode="application/json"
            lineWrapping={true}
            autofocus={false}
            readOnly="nocursor"
            lint={true}
            gutters={['CodeMirror-lint-markers']}
            placeholder="[]"
            />
          <h3>Mappings</h3>
          <CodeMirror
            ref="CodeMirror"
            value={JSON.stringify(this.props.config.get('mappings', Immutable.Map()).toJS(), null, 2)}
            theme="solarized"
            lineNumbers={false}
            mode="application/json"
            lineWrapping={true}
            autofocus={false}
            readOnly="nocursor"
            lint={true}
            gutters={['CodeMirror-lint-markers']}
            placeholder="{}"
            />
        </span>
      );
    } else {
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

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil"></span> {this.props.editLabel}
      </button>
    );
  },

  handleChange() {
    // nothing
  }
});
