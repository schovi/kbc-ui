import React, {PropTypes} from 'react';
import Static from './PackagesStatic';
import Edit from './PackagesEdit';


export default React.createClass({
  propTypes: {
    bucketId: PropTypes.string.isRequired,
    transformation: PropTypes.object.isRequired,
    packages: PropTypes.object.isRequired,
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
        <Edit
          packages={this.props.packages}
          transformationType={this.props.transformation.get('type')}
          isSaving={this.props.isSaving}
          onChange={this.props.onEditChange}
          onCancel={this.props.onEditCancel}
          onSave={this.props.onEditSubmit}
          />
      );
    } else {
      return (
        <Static
          packages={this.props.transformation.get('packages')}
          transformationType={this.props.transformation.get('type')}
          onEditStart={this.props.onEditStart}
          />
      );
    }
  }

});
