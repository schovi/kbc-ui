import React from 'react';
import {ModalTrigger, OverlayTrigger, Tooltip, Button} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';
import classnames from 'classnames';
import RunModal from './LoadDataIntoWorkspaceButtonModal';
import StorageActionCreators from '../../StorageActionCreators';

module.exports = React.createClass({
  displayName: 'LoadDataIntoWorkspace',

  propTypes: {
    title: React.PropTypes.string.isRequired,
    mode: React.PropTypes.oneOf(['button', 'link']),
    runParams: React.PropTypes.func.isRequired,
    icon: React.PropTypes.string.isRequired,
    workspaceId: React.PropTypes.number.isRequired,
    label: React.PropTypes.string,
    tooltip: React.PropTypes.string,
    disabled: React.PropTypes.bool,
    disabledReason: React.PropTypes.string,
    tooltipPlacement: React.PropTypes.string,
    children: React.PropTypes.object
  },

  getDefaultProps: function() {
    return {
      mode: 'button',
      icon: 'fa-play',
      tooltip: 'Run',
      disabled: false,
      disabledReason: '',
      tooltipPlacement: 'top'
    };
  },

  getInitialState: function() {
    return {
      isLoading: false
    };
  },

  _handleRunStart: function() {
    this.setState({
      isLoading: true
    });
    return StorageActionCreators.loadDataIntoWorkspace(this.props.workspaceId, this.props.runParams())
      .then(this._handleStarted)
      .catch((function(_this) {
        return function() {
          _this.setState({
            isLoading: false
          });
        };
      })(this));
  },

  _handleStarted: function() {
    if (this.isMounted()) {
      this.setState({
        isLoading: false
      });
    }
  },

  render: function() {
    const tooltipDisabled = (
      <Tooltip>
        {this.state.isLoading ? 'Data is loading' : this.props.disabledReason}
      </Tooltip>
    );
    const tooltip = (
      <Tooltip>
        {this.props.tooltip}
      </Tooltip>
    );

    const modal = (
      <RunModal
        title={this.props.title}
        body={this.props.children}
        onRequestRun={this._handleRunStart}
      >
        {this._renderButton()}
      </RunModal>
    );

    if (this.props.disabled || this.state.isLoading) {
      return (
        <OverlayTrigger
          overlay={tooltipDisabled}
          placement={this.props.tooltipPlacement}
        >
          {this.props.mode === 'button' ? this._renderButton() : this._renderLink()}
        </OverlayTrigger>
      );
    } else if (this.props.mode === 'button') {
      return (
        <OverlayTrigger
          overlay={tooltip}
          placement={this.props.tooltipPlacement}
        >
          <ModalTrigger modal={modal}>
            {this._renderButton()}
          </ModalTrigger>
        </OverlayTrigger>
      );
    } else {
      return (
        <ModalTrigger modal={modal}>
          {this._renderLink()}
        </ModalTrigger>
      );
    }
  },

  _renderButton: function() {
    return (
      <Button
        className="btn btn-link"
        disabled={this.props.disabled || this.state.isLoading}
        onClick={function(e) {
          e.stopPropagation();
          return e.preventDefault();
        }}
      >
        {this._renderIcon()} {this.props.label ? ' ' + this.props.label : void 0}
      </Button>
    );
  },

  _renderLink: function() {
    return (
      <a className={
        classnames({
          'text-muted': this.props.disabled || this.state.isLoading
        })}
        onClick={function(e) {
          e.stopPropagation();
          return e.preventDefault();
        }}
      >
        {this._renderIcon()} {this.props.title}
      </a>
    );
  },

  _renderIcon: function() {
    if (this.state.isLoading) {
      return (<Loader className="fa-fw" />);
    } else {
      const className = 'fa fa-fw ' + this.props.icon;
      return (<i className={className} />);
    }
  }
});
