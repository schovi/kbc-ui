import React from 'react';
import {ModalTrigger} from 'react-bootstrap';
import OutputMappingModal from '../../modals/OutputMapping';
import actionCreators from '../../../ActionCreators';

export default React.createClass({
  propTypes: {
    tables: React.PropTypes.object.isRequired,
    buckets: React.PropTypes.object.isRequired,
    transformation: React.PropTypes.object.isRequired,
    bucket: React.PropTypes.object.isRequired,
    mapping: React.PropTypes.object.isRequired
  },

  render() {
    return (
      <ModalTrigger modal={this.modal()}>
        <button className="btn btn-primary" onClick={this.handleClick}>
          <span className="kbc-icon-plus" /> Add Output
        </button>
      </ModalTrigger>
    );
  },

  modal() {
    return React.createElement(OutputMappingModal, {
      mode: 'create',
      mapping: this.props.mapping,
      tables: this.props.tables,
      buckets: this.props.buckets,
      backend: this.props.transformation.get('backend'),
      type: this.props.transformation.get('type'),
      onChange: this.handleChange,
      onCancel: this.handleCancel,
      onSave: this.handleSave
    });
  },

  handleClick(e) {
    e.preventDefault();
    e.stopPropagation();
  },

  handleChange(newMapping) {
    actionCreators.updateTransformationEditingField(this.props.bucket.get('id'),
      this.props.transformation.get('id'),
      'new-output-mapping',
      newMapping
    );
  },

  handleCancel() {
    actionCreators.cancelTransformationEditingField(this.props.bucket.get('id'),
      this.props.transformation.get('id'),
      'new-output-mapping'
    );
  },

  handleSave() {
    // returns promise
    return actionCreators.saveTransformationMapping(this.props.bucket.get('id'),
      this.props.transformation.get('id'),
      'output',
      'new-output-mapping'
    );
  }

});