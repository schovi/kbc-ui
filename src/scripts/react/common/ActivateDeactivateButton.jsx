import React from 'react';
import Loader from './Loader';
import Check from './Check';
import {Tooltip, OverlayTrigger} from 'react-bootstrap';

const MODE_BUTTON = 'button', MODE_LINK = 'link';

export default React.createClass({
  propTypes: {
    activateTooltip: React.PropTypes.string.isRequired,
    deactivateTooltip: React.PropTypes.string.isRequired,
    isActive: React.PropTypes.bool.isRequired,
    isPending: React.PropTypes.bool,
    onChange: React.PropTypes.func.isRequired,
    mode: React.PropTypes.oneOf [MODE_BUTTON, MODE_LINK]
  },

  getDefaultProps() {
    return {
      isPending: false,
      mode: MODE_BUTTON
    };
  },

  render() {
    if (this.props.isPending) {
      return (
        <span className="btn btn-link">
          <Loader className="fa-fw"/>
        </span>
      );
    } else {
      return (
        <OverlayTrigger placement="top" overlay={<Tooltip>{this.tooltip()}</Tooltip>}>
          {this.props.mode == MODE_BUTTON ? this.renderButton() : this.renderLink()}
        </OverlayTrigger>
      );
    }
  },

  tooltip() {
    return this.props.isActive ? this.props.deactivateTooltip : this.props.activateTooltip;
  },

  renderButton() {
    return (
      <button className="btn btn-link" onClick={this.handleClick}>
        {this.renderIcon()}
      </button>
    );
  },

  renderLink() {
    return (
      <a onClick={this.handleClick}>
        {this.renderIcon()} {this.tooltip()}
      </a>
    );
  },

  renderIcon() {
    return (
      <Check isChecked={this.props.isActive}/>
    );
  },

  handleClick(e) {
    this.props.onChange(!this.props.isActive);
    e.stopPropagation();
    e.preventDefault();
  }

});
