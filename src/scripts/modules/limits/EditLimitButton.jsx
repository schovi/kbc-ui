import React, {PropTypes} from 'react';
import EditLimitModal from './EditLimitModal';
import {Button} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    limit: PropTypes.object.isRequired
  },

  getInitialState() {
    return {
      isOpen: false
    };
  },

  render() {
    return (
      <Button bsStyle="success" onClick={this.openModal}>
        <span className="kbc-icon-pencil"/> Edit limit
        <EditLimitModal
          limit={this.props.limit}
          onHide={this.closeModal}
          isOpen={this.state.isOpen}
          />
      </Button>
    );
  },

  openModal() {
    this.setState({
      isOpen: true
    });
  },

  closeModal() {
    this.setState({
      isOpen: false
    });
  }
});