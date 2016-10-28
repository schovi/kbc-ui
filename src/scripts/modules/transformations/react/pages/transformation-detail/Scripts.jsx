import React, {PropTypes} from 'react';
import Static from './ScriptsStatic';
import Edit from './ScriptsEdit';
import Clipboard from '../../../../../react/common/Clipboard';

/* global require */
require('codemirror/mode/r/r');
require('codemirror/mode/python/python');

export default React.createClass({
  propTypes: {
    bucketId: PropTypes.string.isRequired,
    transformation: PropTypes.object.isRequired,
    scripts: PropTypes.string.isRequired,
    isEditing: PropTypes.bool.isRequired,
    isEditingValid: PropTypes.bool.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onEditStart: PropTypes.func.isRequired,
    onEditCancel: PropTypes.func.isRequired,
    onEditChange: PropTypes.func.isRequired,
    onEditSubmit: PropTypes.func.isRequired
  },

  render() {
    return (
      <div>
        <h2>
          Scripts <small><Clipboard text={this.props.scripts}/></small>
        </h2>
        {this.scripts()}
      </div>
    );
  },

  scripts() {
    if (this.props.isEditing) {
      return (
        <Edit
          script={this.props.scripts}
          transformationType={this.props.transformation.get('type')}
          isValid={this.props.isEditingValid}
          isSaving={this.props.isSaving}
          onSave={this.props.onEditSubmit}
          onChange={this.props.onEditChange}
          onCancel={this.props.onEditCancel}
          />
      );
    } else {
      return (
        <Static
          script={this.props.scripts}
          transformationType={this.props.transformation.get('type')}
          onEditStart={this.props.onEditStart}
          />
      );
    }
  }

});
