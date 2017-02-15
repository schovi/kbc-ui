import React from 'react';
import {MenuItem} from 'react-bootstrap';
import VersionsDiffModal from './VersionsDiffModal';
import {Loader} from 'kbc-react-components';
import {Tooltip} from '../../react/common/common';

export default React.createClass({

  propTypes: {
    version: React.PropTypes.object.isRequired,
    previousVersion: React.PropTypes.object.isRequired,
    onLoadVersionConfig: React.PropTypes.func.isRequired,
    isPending: React.PropTypes.bool,
    isDisabled: React.PropTypes.bool
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
    this.props.onLoadVersionConfig().then(() =>
      this.setState({'showModal': true})
    );
  },

  render() {
    if (this.props.isPending) {
      return (
        <MenuItem
          eventKey={this.props.version.get('version') + '-diff'}
          disabled
        >
          <Loader/> Compare
        </MenuItem>
      );
    } else {
      const tooltipMsg = `Compare prior changes(#${this.props.version.get('version')} vs #${this.props.previousVersion.get('version')})`;
      return (
        <Tooltip tooltip={tooltipMsg} placement="left">
          <MenuItem
            eventKey={this.props.version.get('version') + '-diff'}
            onSelect={this.openModal}
            disabled={this.props.isDisabled}
          >
            <em className="fa fa-fw fa-files-o" />
            Compare
            <VersionsDiffModal
              onClose={this.closeModal}
              show={this.state.showModal}
              referentialVersion={this.props.version}
              compareVersion={this.props.previousVersion}
            />
          </MenuItem>
        </Tooltip>
      );
    }
  }

});
