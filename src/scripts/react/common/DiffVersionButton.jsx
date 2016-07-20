import React from 'react';
import {Tooltip} from '../../react/common/common';
import VersionsDiffModal from './VersionsDiffModal';
import {Loader} from 'kbc-react-components';

export default React.createClass({

  propTypes: {
    version: React.PropTypes.object.isRequired,
    previousVersion: React.PropTypes.object.isRequired,
    isPending: React.PropTypes.bool,
    isDisabled: React.PropTypes.bool,
    onLoadVersionConfig: React.PropTypes.func
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
    this.props.onLoadVersionConfig().then( () =>
      this.setState({'showModal': true})
    );
  },

  render() {
    if (this.props.isPending) {
      return (
        <span className="btn btn-link">
          <Loader/>
        </span>
      );
    } else {
      const tooltipMsg = `Compare prior changes(#${this.props.version.get('version')} vs #${this.props.previousVersion.get('version')})`;
      return (
        <Tooltip tooltip={tooltipMsg} placement="top">
          <button className="btn btn-link" disabled={this.props.isDisabled} onClick={this.openModal}>
            <em className="fa fa-fw fa-files-o"> </em>
            <VersionsDiffModal
              onClose={this.closeModal}
              show={this.state.showModal}
              referentialVersion={this.props.version}
              compareVersion={this.props.previousVersion}
            />
          </button>
        </Tooltip>
      );
    }
  }
});
