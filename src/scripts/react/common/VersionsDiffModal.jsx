import React from 'react';
import {Modal} from 'react-bootstrap';

export default React.createClass({

  propTypes: {
    version: React.PropTypes.object.isRequired,
    show: React.PropTypes.bool.isRequired,
    onClose: React.PropTypes.func.isRequired,
    onRollback: React.PropTypes.func.isRequired
  },

  render() {
    return (
      <Modal show={this.props.show} onHide={this.props.onClose}>
        <Modal.Header closeButton>
          <Modal.Title>Versions Diff</Modal.Title>
        </Modal.Header>
        <Modal.Body>
        </Modal.Body>
      </Modal>
    );
  }
});
