import React, {PropTypes} from 'react';
import Static from './RequiresStatic';
import Edit from './RequiresEdit';


export default React.createClass({
  propTypes: {
    bucketId: PropTypes.string.isRequired,
    transformation: PropTypes.object.isRequired,
    transformations: PropTypes.object.isRequired,
    requires: PropTypes.object.isRequired,
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
          transformation={this.props.transformation}
          transformations={this.props.transformations}
          isSaving={this.props.isSaving}
          requires={this.props.requires}
          onChange={this.props.onEditChange}
          onCancel={this.props.onEditCancel}
          onSave={this.props.onEditSubmit}
          />
      );
    } else {
      return (
        <Static
          bucketId={this.props.bucketId}
          transformation={this.props.transformation}
          transformations={this.props.transformations}
          onEditStart={this.props.onEditStart}
          />
      );
    }
  }

});