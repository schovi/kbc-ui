import React from 'react';
import InstalledComponentsActionCreators from '../../InstalledComponentsActionCreators';
import {ModalTrigger, Modal, ButtonToolbar, OverlayTrigger, Tooltip, Button} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';
import RoutesStore from '../../../../stores/RoutesStore';
import classnames from 'classnames';

var RunModal = React.createClass({

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

module.exports = React.createClass({
  displayName: 'RunExtraction',

  propTypes: {
    title: React.PropTypes.string.isRequired,
    mode: React.PropTypes.oneOf(['button', 'link']),
    component: React.PropTypes.string.isRequired,
    runParams: React.PropTypes.func.isRequired,
    method: React.PropTypes.string.isRequired,
    icon: React.PropTypes.string.isRequired,
    label: React.PropTypes.string,
    redirect: React.PropTypes.bool,
    tooltip: React.PropTypes.string,
    disabled: React.PropTypes.bool,
    disabledReason: React.PropTypes.string,
    tooltipPlacement: React.PropTypes.string,
    children: React.PropTypes.object
  },

  getDefaultProps: function() {
    return {
      mode: 'button',
      method: 'run',
      icon: 'fa-play',
      redirect: false,
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
    var params;
    this.setState({
      isLoading: true
    });
    params = {
      method: this.props.method,
      component: this.props.component,
      data: this.props.runParams(),
      notify: !this.props.redirect
    };

    return InstalledComponentsActionCreators.runComponent(params)
      .then(this._handleStarted)
      .catch((function(_this) {
        return function(error) {
          _this.setState({
            isLoading: false
          });
          throw error;
        };
      })(this));
  },

  _handleStarted: function(response) {
    if (this.isMounted()) {
      this.setState({
        isLoading: false
      });
    }
    if (this.props.redirect) {
      return RoutesStore.getRouter().transitionTo('jobDetail', {
        jobId: response.id
      });
    }
  },

  render: function() {
    const tooltipDisabled = (
      <Tooltip>
        {this.props.disabledReason}
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

    if (this.props.disabled) {
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
        disabled={this.props.disabled}
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
          'text-muted': this.props.disabled
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

// ---
// generated by coffee-script 1.9.2
