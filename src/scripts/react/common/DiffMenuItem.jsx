import React from 'react';
import {MenuItem} from 'react-bootstrap';
import VersionsDiffModal from './VersionsDiffModal';
import {Loader} from 'kbc-react-components';

export default React.createClass({

  propTypes: {
    version: React.PropTypes.object.isRequired,
    referenceConfigData: React.PropTypes.object.isRequired,
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
          <em className="fa fa-fw">
            <Loader/>
          </em>
          Diff with current configuration
        </MenuItem>
      );
    } else {
      return (
        <MenuItem
          eventKey={this.props.version.get('version') + '-diff'}
          onSelect={this.openModal}
          disabled={this.props.isDisabled}
        >
          <em className="fa fa-fw fa-files-o"> </em>
          Compare
          <VersionsDiffModal
            onClose={this.closeModal}
            show={this.state.showModal}
            referenceConfigData={this.props.version.get('configuration')}
            compareConfigData={ this.getPreviousVersionConfigData()}
            version={this.props.version}
          />
        </MenuItem>
      );
    }
  },

  getPreviousVersionConfigData() {
    if (this.props.previousVersion) {
      return this.props.previousVersion.get('configuration');
    }
    return null;
  }
});
