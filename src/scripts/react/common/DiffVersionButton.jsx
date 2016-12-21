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
    isSmall: React.PropTypes.bool,
    onLoadVersionConfig: React.PropTypes.func,
    tooltipMsg: React.PropTypes.string,
    buttonText: React.PropTypes.string,
    buttonClassName: React.PropTypes.object,
    buttonAsSpan: React.PropTypes.bool
  },

  getInitialState() {
    return {
      showModal: false
    };
  },

  getDefaultProps() {
    return {
      buttonClassName: 'btn btn-link'
    };
  },

  closeModal() {
    this.setState({'showModal': false});
  },

  openModal() {
    if (this.props.isDisabled || this.props.isPending) return;
    this.props.onLoadVersionConfig().then( () =>
      this.setState({'showModal': true})
    );
  },

  render() {
    const tooltipMsg = `Compare with previous (#${this.props.previousVersion.get('version')} to #${this.props.version.get('version')})`;
    const content = [
      this.props.isSmall ?
      (<small>
        {this.renderIcon()}
        {this.props.buttonText}
      </small>)
      :
      (<span className="text-muted">
        {this.renderIcon()}
        {this.props.buttonText}
      </span>),
      this.renderDiffModal()
    ];

    const elemProps = {
      className: this.props.buttonClassName,
      style: {cursor: 'pointer'},
      disabled: this.props.isDisabled,
      onClick: this.openModal
    };

    const element =
      this.props.buttonAsSpan ?
      <span {...elemProps}> {content}</span>
      :
      <button {...elemProps}> {content} </button>;

    return (
      <Tooltip tooltip={this.props.tooltipMsg || tooltipMsg} placement="top">
        {element}
      </Tooltip>
    );
  },

  renderDiffModal() {
    return (
      <VersionsDiffModal
        onClose={this.closeModal}
        show={this.state.showModal}
        referentialVersion={this.props.versionConfig}
        compareVersion={this.props.previousVersionConfig}
      />
    );
  },

  renderIcon() {
    if (this.props.isPending) {
      return <Loader className="fa-fw"/>;
    }

    return <em className="fa fa-fw fa-files-o" />;
  }
});
