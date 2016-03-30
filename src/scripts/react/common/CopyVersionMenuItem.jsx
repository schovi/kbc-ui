import React from 'react';
import {MenuItem} from 'react-bootstrap';
import CopyVersionModal from './CopyVersionModal';

export default React.createClass({

  propTypes: {
    version: React.PropTypes.object.isRequired,
    onCopy: React.PropTypes.func.isRequired,
    newVersionName: React.PropTypes.string,
    onChangeName: React.PropTypes.func.isRequired
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

  onCopy() {
    this.props.onCopy();
    this.closeModal();
  },

  render() {
    return (
      <MenuItem
        eventKey={this.props.version.get('version') + '-copy'}
        onSelect={this.openModal}
      >
        <em className="fa fa-files-o fa-fw"> </em>
        Copy to new
        <CopyVersionModal
          version={this.props.version}
          show={this.state.showModal}
          onClose={this.closeModal}
          onCopy={this.onCopy}
          onChangeName={this.props.onChangeName}
          newVersionName={this.props.newVersionName}
        />
      </MenuItem>
    );
  }
});
