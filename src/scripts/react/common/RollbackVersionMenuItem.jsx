import React from 'react';
import {MenuItem} from 'react-bootstrap';
import RollbackVersionModal from './RollbackVersionModal';

export default React.createClass({

  propTypes: {
    version: React.PropTypes.object.isRequired,
    onRollback: React.PropTypes.func.isRequired
  },

  getInitialState() {
    return {
      showModal: false
    };
  },

  closeModal() {
    this.setState({'showModal': false});
  },

  openModal() {
    this.setState({'showModal': true});
  },

  onRollback() {
    this.props.onRollback();
    this.closeModal();
  },

  render() {
    return (
      <MenuItem
        eventKey={this.props.version.get('version') + '-rollback'}
        onSelect={this.openModal}
      >
        <em className="fa fa-undo fa-fw"> </em>
        Rollback
        <RollbackVersionModal
          version={this.props.version}
          show={this.state.showModal}
          onClose={this.closeModal}
          onRollback={this.onRollback}
        />
      </MenuItem>
    );
  }
});
