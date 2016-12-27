import React from 'react';
import {Modal, Button} from 'react-bootstrap';
import CreateDockerSandboxForm from '../components/CreateDockerSandboxForm';

module.exports = React.createClass({
  displayName: 'CreateDockerSandboxModal',
  propTypes: {
    show: React.PropTypes.bool.isRequired,
    close: React.PropTypes.func.isRequired,
    create: React.PropTypes.func.isRequired,
    tables: React.PropTypes.object.isRequired,
    type: React.PropTypes.string.isRequired,
    onConfigurationChange: React.PropTypes.func.isRequired
  },
  render: function() {
    return (
      <Modal show={this.props.show} onHide={this.props.close} bsSize="large">
        <Modal.Header closeButton>
          <Modal.Title>Create {this.props.type} Sandbox</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <CreateDockerSandboxForm
            tables={this.props.tables}
            type={this.props.type}
            onChange={this.props.onConfigurationChange}
          />
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.close} bsStyle="link">Close</Button>
          <Button onClick={this.create} bsStyle="primary">Create</Button>
        </Modal.Footer>
      </Modal>
    );
  },
  create: function() {
    this.props.create();
    this.props.close();
  }
});

