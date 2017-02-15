import React from 'react';
import {ModalTrigger} from 'react-bootstrap';
import InputMappingModal from '../../modals/InputMapping';
import actionCreators from '../../../ActionCreators';

export default React.createClass({
  propTypes: {
    tables: React.PropTypes.object.isRequired,
    transformation: React.PropTypes.object.isRequired,
    bucket: React.PropTypes.object.isRequired,
    mapping: React.PropTypes.object.isRequired,
    otherDestinations: React.PropTypes.object.isRequired
  },

  render() {
    return (
      <ModalTrigger modal={this.modal()}>
        <button className="btn btn-primary" onClick={this.handleClick}>
          <span className="kbc-icon-plus" /> Add Input
        </button>
      </ModalTrigger>
    );
  },

  modal() {
    return React.createElement(InputMappingModal, {
      mode: 'create',
      mapping: this.props.mapping,
      tables: this.props.tables,
      backend: this.props.transformation.get('backend'),
      type: this.props.transformation.get('type'),
      onChange: this.handleChange,
      onCancel: this.handleCancel,
      onSave: this.handleSave,
      otherDestinations: this.props.otherDestinations
    });
  },

  handleClick(e) {
    e.preventDefault();
    e.stopPropagation();
  },

  handleChange(newMapping) {
    actionCreators.updateTransformationEditingField(this.props.bucket.get('id'),
      this.props.transformation.get('id'),
      'new-input-mapping',
      newMapping
    );
  },

  handleCancel() {
    actionCreators.cancelTransformationEditingField(this.props.bucket.get('id'),
      this.props.transformation.get('id'),
      'new-input-mapping'
    );
  },

  handleSave() {
    // returns promise
    return actionCreators.saveTransformationMapping(this.props.bucket.get('id'),
      this.props.transformation.get('id'),
      'input',
      'new-input-mapping'
    );
  }

});
