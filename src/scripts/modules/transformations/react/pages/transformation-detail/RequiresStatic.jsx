import React, {PropTypes} from 'react';
import {Link} from 'react-router';


export default React.createClass({
  propTypes: {
    bucketId: PropTypes.string.isRequired,
    transformation: PropTypes.object.isRequired,
    transformations: PropTypes.object.isRequired,
    onEditStart: PropTypes.func.isRequired
  },

  render() {
    return this.props.transformation.get('requires').count() ? this.transformationsList() :
      this.emptyState();
  },

  transformationsList() {
    return (
      <div>
        <div className="help-block">
          These transformations are processed before this transformation starts.
        </div>
        <div>
          {this.props.transformation.get('requires').map(this.transformation, this)}

          {this.startEditButton()}
        </div>
      </div>
    );
  },

  emptyState() {
    return (
      <div className="help-block">
        <small>No transformations are required.</small> {this.startEditButton()}
      </div>
    );
  },

  transformation(transformationId) {
    return (
      <Link to="transformationDetail" key={transformationId} params={{row: transformationId, config: this.props.bucketId}}>
        <span className="label kbc-label-rounded-small label-default">
          {this.findTransformationById(transformationId)}
        </span>
      </Link>
    );
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil" /> Edit Required Transformations
      </button>
    );
  },

  findTransformationById(transformationId) {
    const foundTransformation = this.props.transformations.find((transformation) => {
      return transformation.get('id') === transformationId;
    });
    return foundTransformation ? foundTransformation.get('name') : transformationId;
  }

});
