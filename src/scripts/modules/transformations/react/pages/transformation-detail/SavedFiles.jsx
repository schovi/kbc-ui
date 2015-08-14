import React, {PropTypes} from 'react';
import Static from './SavedFilesStatic';
import Edit from './SavedFilesEdit';


export default React.createClass({
  propTypes: {
    tags: PropTypes.object.isRequired,
    isEditing: PropTypes.bool.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onEditStart: PropTypes.func.isRequired,
    onEditCancel: PropTypes.func.isRequired,
    onEditChange: PropTypes.func.isRequired,
    onEditSubmit: PropTypes.func.isRequired
  },

  render() {
    if (this.props.isEditing) {
      return (
        <div>
          {this.renderHelp()}
        <Edit
          tags={this.props.tags}
          isSaving={this.props.isSaving}
          onChange={this.props.onEditChange}
          onCancel={this.props.onEditCancel}
          onSave={this.props.onEditSubmit}
          />
        </div>
      );
    } else {
      return (
        <div>
          {this.renderHelp()}
          <Static
          tags={this.props.tags}
          onEditStart={this.props.onEditStart}
          />
        </div>
      );
    }
  },

  renderHelp() {
    return (
      <div className="help-block">
        The latest file with a given tag will be saved to <code>/data/in/user/&#123;tag&#125;</code>.
        The transformation will fail when no files found with for a given tag.
      </div>
    );
  }


});
