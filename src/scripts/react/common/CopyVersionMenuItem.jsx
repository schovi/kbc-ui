import React from 'react';
import {MenuItem} from 'react-bootstrap';
import CopyVersionModal from './CopyVersionModal';
import {Loader} from 'kbc-react-components';
import {Tooltip} from '../../react/common/common';

export default React.createClass({

  propTypes: {
    version: React.PropTypes.object.isRequired,
    onCopy: React.PropTypes.func.isRequired,
    newVersionName: React.PropTypes.string,
    onChangeName: React.PropTypes.func.isRequired,
    isPending: React.PropTypes.bool,
    isDisabled: React.PropTypes.bool
  },

  getInitialState() {
    return {
      showModal: false
    };
  },

  closeModal() {
    this.props.onChangeName();
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
    if (this.props.isPending) {
      return (
        <MenuItem
          eventKey={this.props.version.get('version') + '-copy'}
          disabled
        >
          <em className="fa fa-fw">
            <Loader/>
          </em>
          Copy to new
        </MenuItem>
      );
    } else {
      return (
        <Tooltip tooltip="Create new configuration from this" placement="left">
          <MenuItem
            eventKey={this.props.version.get('version') + '-copy'}
            onSelect={this.openModal}
            disabled={this.props.isDisabled}
          >
            <em className="fa fa-code-fork fa-fw" />
            Copy
            <CopyVersionModal
              version={this.props.version}
              show={this.state.showModal}
              onClose={this.closeModal}
              onCopy={this.onCopy}
              onChangeName={this.props.onChangeName}
              newVersionName={this.props.newVersionName}
            />
          </MenuItem>
        </Tooltip>
      );
    }
  }
});
