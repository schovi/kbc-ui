import React, {PropTypes} from 'react';
import JSONSchemaEditor from './JSONSchemaEditor';
import Markdown from 'react-markdown';
import CodeMirror from 'react-code-mirror';

/* global require */
require('./configuration-json.less');

export default React.createClass({

  propTypes: {
    jobs: PropTypes.object.isRequired,
    params: PropTypes.object.isRequired,
    api: PropTypes.object.isRequired,
    paramsSchema: PropTypes.object.isRequired,
    jobsTemplates: PropTypes.object.isRequired,
    apiSchema: PropTypes.object.isRequired,
    apiTemplate: PropTypes.object.isRequired,
    onEditStart: PropTypes.func,
    requiresApiSchema: PropTypes.bool.isRequired,
    editLabel: PropTypes.string
  },

  getDefaultProps() {
    return {
      editLabel: 'Edit configuration'
    };
  },

  render() {
    if (this.props.requiresApiSchema) {
      return !this.props.params.isEmpty() || !this.props.api.isEmpty() || !this.props.jobs.isEmpty() ? this.static() : this.emptyState();
    } else {
      return !this.props.params.isEmpty() || !this.props.jobs.isEmpty() ? this.static() : this.emptyState();
    }
  },

  static() {
    return (
      <div>
        <div className="edit kbc-configuration-editor">
          <div className="text-right">{this.startEditButton()}</div>
          {this.apiEditor()}
          <JSONSchemaEditor
            schema={this.props.paramsSchema}
            value={this.props.params}
            onChange={this.handleChange}
            readOnly={true}
          />
          {this.renderJobs()}
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
    return this.props.jobsTemplates.filter(
      function(template) {
        return template.get('jobs').hashCode() === parseInt(hashCode, 10);
      }
    ).first();
  },

  renderJobs() {
    var template = this.getTemplate(this.props.jobs.hashCode());
    if (!template) {
      return (
        <span>
          <h3>Jobs</h3>
          <CodeMirror
            ref="CodeMirror"
            value={JSON.stringify(this.props.jobs.toJS(), null, 2)}
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

  apiEditor() {
    if (this.props.requiresApiSchema) {
      return (
        <JSONSchemaEditor
          schema={this.props.apiSchema}
          value={this.props.api.toJS()}
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

  handleChange() {
    // nothing
  }
});
