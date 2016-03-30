import React from 'react';
import {Tooltip} from '../../react/common/common';
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
      <Tooltip tooltip="Rollback this version" placement="top">
        <button className="btn btn-link" onClick={this.openModal}>
          <em className="fa fa-undo fa-fw"> </em>
          <RollbackVersionModal
            version={this.props.version}
            show={this.state.showModal}
            onClose={this.closeModal}
            onRollback={this.onRollback}
          />
        </button>
      </Tooltip>
    );
  }
});
