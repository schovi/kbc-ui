import React, {PropTypes} from 'react';
import Static from './ConfigurationStatic';
import Edit from './ConfigurationEdit';
import Immutable from 'immutable';
import Markdown from '../../../../react/common/Markdown';

/* global require */
require('codemirror/mode/javascript/javascript');

export default React.createClass({
  propTypes: {
    data: PropTypes.string.isRequired,
    isEditing: PropTypes.bool.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onEditStart: PropTypes.func.isRequired,
    onEditCancel: PropTypes.func.isRequired,
    onEditChange: PropTypes.func.isRequired,
    onEditSubmit: PropTypes.func.isRequired,
    isValid: PropTypes.bool.isRequired,
    supportsEncryption: PropTypes.bool.isRequired,
    headerText: PropTypes.string,
    editLabel: PropTypes.string,
    saveLabel: PropTypes.string,
    help: PropTypes.node,
    schema: PropTypes.object,
    editHelp: PropTypes.string,
    documentationUrl: PropTypes.string,
    showDocumentationLink: PropTypes.bool
  },

  getDefaultProps() {
    return {
      headerText: 'Configuration',
      help: null,
      editLabel: 'Edit configuration',
      saveLabel: 'Save configuration',
      schema: Immutable.Map(),
      showDocumentationLink: true
    };
  },

  render() {
    return (
      <div>
        <h2>{this.props.headerText}</h2>
        {this.props.help}
        {this.renderDocumentationUrl()}
        {this.renderHelp()}
        {this.scripts()}
      </div>
    );
  },

  renderHelp() {
    if (!this.props.editHelp) {
      return null;
    }
    return (
      <Markdown
        source={this.props.editHelp}
        height="small"
        />
    );
  },

  renderDocumentationUrl() {
    if (!this.props.documentationUrl) {
      return null;
    }
    if (this.props.editHelp) {
      return null;
    }
    if (this.props.schema.count()) {
      return null;
    }
    if (this.props.showDocumentationLink) {
      return (
        <p className="help-block">This component is configured manually. Read the <a href={this.props.documentationUrl}>configuration
          documentation</a> for more information.</p>
      );
    }
    return null;
  },

  scripts() {
    if (this.props.isEditing) {
      return this.renderEditor();
    } else {
      return (
        <Static
          data={this.props.data}
          schema={this.props.schema}
          onEditStart={this.props.onEditStart}
          editLabel={this.props.editLabel}
          />
      );
    }
  },

  renderEditor() {
    return (
      <Edit
        data={this.props.data}
        schema={this.props.schema}
        isSaving={this.props.isSaving}
        onSave={this.props.onEditSubmit}
        onChange={this.props.onEditChange}
        onCancel={this.props.onEditCancel}
        isValid={this.props.isValid}
        saveLabel={this.props.saveLabel}
        supportsEncryption={this.props.supportsEncryption}
        help={this.props.editHelp}
      />
    );
  }
});
