import React from 'react';
import {Modal, ButtonToolbar, Button} from 'react-bootstrap';

module.exports = React.createClass({

  propTypes: {
    onRequestHide: React.PropTypes.func.isRequired,
    onRequestRun: React.PropTypes.func.isRequired,
    title: React.PropTypes.string.isRequired,
    body: React.PropTypes.string.isRequired
  },

  _handleRun: function() {
    this.props.onRequestHide();
    return this.props.onRequestRun();
  },

  render: function() {
    return (
      <Modal
        title={this.props.title}
        onRequestHide={this.props.onRequestHide}
      >
        <div className="modal-body">
          {this.props.body}
        </div>
        <div className="modal-footer">
          <ButtonToolbar>
            <Button bsStyle="link" onClick={this.props.onRequestHide}>Close</Button>
            <Button bsStyle="primary" onClick={this._handleRun}>Run</Button>
          </ButtonToolbar>
        </div>
      </Modal>
    );
  }
});
