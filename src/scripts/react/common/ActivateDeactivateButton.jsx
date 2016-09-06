import React from 'react';
import {Check, Loader} from 'kbc-react-components';
import {Tooltip, OverlayTrigger} from 'react-bootstrap';

const MODE_BUTTON = 'button', MODE_LINK = 'link';

export default React.createClass({
  propTypes: {
    activateTooltip: React.PropTypes.string.isRequired,
    deactivateTooltip: React.PropTypes.string.isRequired,
    isActive: React.PropTypes.bool.isRequired,
    isPending: React.PropTypes.bool,
    onChange: React.PropTypes.func.isRequired,
    mode: React.PropTypes.oneOf([MODE_BUTTON, MODE_LINK]),
    tooltipPlacement: React.PropTypes.string,
    buttonStyle: React.PropTypes.object
  },

  getDefaultProps() {
    return {
      isPending: false,
      mode: MODE_BUTTON,
      tooltipPlacement: 'top',
      buttonStyle: {}
    };
  },

  render() {
    if (this.props.mode === MODE_BUTTON) {
      return this.renderButton();
    } else {
      return this.renderLink();
    }
  },

  tooltip() {
    return this.props.isActive ? this.props.deactivateTooltip : this.props.activateTooltip;
  },

  renderButton() {
    if (this.props.isPending) {
      return (
        <span className="btn btn-link" style={this.props.buttonStyle}>
          <Loader className="fa-fw"/>
        </span>
      );
    } else {
      return (
        <OverlayTrigger placement={this.props.tooltipPlacement} overlay={<Tooltip>{this.tooltip()}</Tooltip>}>
          <button style={this.props.buttonStyle} className="btn btn-link" onClick={this.handleClick}>
            {this.renderIcon(this.props.isActive)}
          </button>
        </OverlayTrigger>
      );
    }
  },

  renderLink() {
    return (
      <a onClick={this.handleClick}>
        {this.props.isPending ? <Loader className="fa-fw"/> : this.renderIcon(!this.props.isActive)} {this.tooltip()}
      </a>
    );
  },

  renderIcon(isChecked) {
    return (
      <Check isChecked={isChecked}/>
    );
  },

  handleClick(e) {
    this.props.onChange(!this.props.isActive);
    e.stopPropagation();
    e.preventDefault();
  }

});
