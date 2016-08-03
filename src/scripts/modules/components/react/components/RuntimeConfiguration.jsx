import React, {PropTypes} from 'react';
import Static from './RuntimeConfigurationStatic';
import Edit from './RuntimeConfigurationEdit';

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
    headerText: PropTypes.string,
    editLabel: PropTypes.string,
    saveLabel: PropTypes.string
  },

  getDefaultProps() {
    return {
      headerText: 'Runtime',
      editLabel: 'Edit configuration',
      saveLabel: 'Save configuration'
    };
  },

  render() {
    return (
      <div>
        <h2>{this.props.headerText}</h2>
        {this.renderEditor()}
      </div>
    );
  },

  renderEditor() {
    if (this.props.isEditing) {
      return (
        <Edit
          data={this.props.data}
          isSaving={this.props.isSaving}
          onSave={this.props.onEditSubmit}
          onChange={this.props.onEditChange}
          onCancel={this.props.onEditCancel}
          saveLabel={this.props.saveLabel}
        />
      );
    } else {
      return (
        <Static
          data={this.props.data}
          onEditStart={this.props.onEditStart}
          editLabel={this.props.editLabel}
          />
      );
    }
  }


});
