import React from 'react';
import {Tooltip} from '../../react/common/common';
import VersionsDiffModal from './VersionsDiffModal';
import {Loader} from 'kbc-react-components';

export default React.createClass({

  propTypes: {
    version: React.PropTypes.object.isRequired,
    versionConfig: React.PropTypes.object.isRequired,
    previousVersion: React.PropTypes.object.isRequired,
    previousVersionConfig: React.PropTypes.object.isRequired,
    isPending: React.PropTypes.bool,
    isDisabled: React.PropTypes.bool,
    onLoadVersionConfig: React.PropTypes.func,
    tooltipMsg: React.PropTypes.string,
    buttonStyle: React.PropTypes.object
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
        <span className="btn btn-link" style={this.props.buttonStyle}>
          <Loader className="fa-fw"/>
        </span>
      );
    } else {
      const tooltipMsg = `Compare with previous (#${this.props.previousVersion.get('version')} to #${this.props.version.get('version')})`;
      return (
        <Tooltip tooltip={this.props.tooltipMsg || tooltipMsg} placement="top">
          <button className="btn btn-link"
            style={this.props.buttonStyle}
            disabled={this.props.isDisabled} onClick={this.openModal}>
            <em className="fa fa-fw fa-files-o"> </em>
            <VersionsDiffModal
              onClose={this.closeModal}
              show={this.state.showModal}
              referentialVersion={this.props.versionConfig}
              compareVersion={this.props.previousVersionConfig}
            />
          </button>
        </Tooltip>
      );
    }
  }
});
