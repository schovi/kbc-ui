import React, {PropTypes} from 'react';
import InlineEditArea from '../../../../../react/common/InlineEditArea';
import {saveJobErrorNote} from '../../../JobsApi';

export default React.createClass({
  propTypes: {
    jobId: PropTypes.number.isRequired,
    errorNote: PropTypes.string,
    onSave: PropTypes.func.isRequired,
    canEdit: PropTypes.bool.isRequired
  },

  getInitialState() {
    return {
      isEditing: false,
      isSaving: false,
      errorNote: ''
    };
  },

  render() {
    if (this.props.canEdit) {
      return (
        <div>
          <strong>Error Note</strong><br/>
          <span>{this.inlineEdit()}</span>
        </div>
      );
    } else if (this.props.errorNote) {
      return (
        <p>
          <strong>Note from support</strong><br/>
          <span>{this.props.errorNote}</span>
        </p>
      );
    } else {
      return null;
    }
  },

  inlineEdit() {
    return React.createElement(InlineEditArea, {
      onEditStart: this.handleStart,
      onEditCancel: this.handleCancel,
      onEditChange: this.handleUpdate,
      onEditSubmit: this.handleSave,
      isEditing: this.state.isEditing,
      isSaving: this.state.isSaving,
      text: this.state.isEditing ? this.state.errorNote : this.props.errorNote
    });
  },

  handleStart() {
    this.setState({
      errorNote: this.props.errorNote,
      isEditing: true
    });
  },

  handleUpdate(newValue) {
    this.setState({
      errorNote: newValue
    });
  },

  handleCancel() {
    this.setState({
      errorNote: '',
      isEditing: false
    });
  },

  handleSave() {
    this.setState({
      isSaving: true
    });
    saveJobErrorNote(this.props.jobId, this.state.errorNote)
    .then(this.handleSaveSuccess)
    .catch(this.handleSaveError);
  },

  handleSaveSuccess() {
    this.setState({
      isSaving: false,
      isEditing: false
    });
    this.props.onSave(this.state.errorNote);
  },

  handleSaveError(error) {
    this.setState({
      isSaving: false
    });
    throw error;
  }

});