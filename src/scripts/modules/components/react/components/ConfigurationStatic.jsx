import React, {PropTypes} from 'react';
import CodeMirror from 'react-code-mirror';
import JSONSchemaEditor from './JSONSchemaEditor';
import Immutable from 'immutable';

export default React.createClass({
  propTypes: {
    data: PropTypes.string.isRequired,
    schema: PropTypes.object,
    onEditStart: PropTypes.func.isRequired,
    editLabel: PropTypes.string
  },

  getDefaultProps() {
    return {
      editLabel: 'Edit configuration',
      schema: Immutable.Map()
    };
  },

  render() {
    return this.props.data && this.props.data.length ? this.script() : this.emptyState();
  },

  script() {
    return (
      <div className="edit kbc-configuration-editor">
        <div className="text-right">{this.startEditButton()}</div>
        {this.renderJSONSchemaEditor()}
        {this.renderCodeMirror()}
      </div>
    );
  },

  renderJSONSchemaEditor() {
    if (this.props.schema.isEmpty()) {
      return null;
    }
    return (
      <JSONSchemaEditor
        schema={this.props.schema}
        value={Immutable.fromJS(JSON.parse(this.props.data))}
        onChange={this.handleChange}
        readOnly={true}
      />
    );
  },

  renderCodeMirror() {
    if (!this.props.schema.isEmpty()) {
      return null;
    }
    return (
      <CodeMirror
        theme="solarized"
        lineNumbers={true}
        defaultValue={this.props.data}
        readOnly={true}
        cursorHeight={0}
        mode="application/json"
        lineWrapping={true}
        />
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
        <span className="kbc-icon-pencil" /> {this.props.editLabel}
      </button>
    );
  },

  handleChange() {
    // nothing
  }
});
