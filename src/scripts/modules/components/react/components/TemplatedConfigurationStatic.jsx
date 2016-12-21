import React, {PropTypes} from 'react';
import JSONSchemaEditor from './JSONSchemaEditor';
import Markdown from '../../../../react/common/Markdown';
import CodeMirror from 'react-code-mirror';

/* global require */
require('./configuration-json.less');

export default React.createClass({

  propTypes: {
    config: PropTypes.object.isRequired,
    isTemplate: PropTypes.bool.isRequired,
    template: PropTypes.object.isRequired,
    params: PropTypes.object.isRequired,
    paramsSchema: PropTypes.object.isRequired,
    onEditStart: PropTypes.func,
    editLabel: PropTypes.string
  },

  getDefaultProps() {
    return {
      editLabel: 'Edit configuration'
    };
  },

  render() {
    return !this.props.config.isEmpty() ? this.static() : this.emptyState();
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
          {this.renderConfig()}
        </div>
      </div>
    );
  },

  emptyState() {
    return (
      <p>
        <small>Configuration empty.</small> {this.startEditButton()}
      </p>
    );
  },

  renderConfig() {
    if (!this.props.isTemplate) {
      return (
        <span>
          <CodeMirror
            ref="config"
            value={JSON.stringify(this.props.config.toJS(), null, 2)}
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
          {this.renderJSONSchemaEditor()}
          <h3>{this.props.template.get('name')}</h3>
          <Markdown
            source={this.props.template.get('description')}
            />
        </span>
      );
    }
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil" /> {this.props.editLabel}
      </button>
    );
  },

  handleChange() {
    // nothing
  }
});
