import React, {PropTypes} from 'react';
import {OverlayTrigger, Tooltip} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    tooltip: PropTypes.string.isRequired,
    children: PropTypes.any,
    placement: PropTypes.string
  },

  getDefaultProps() {
    return {
      placement: 'right'
    };
  },

  render() {
    return (
        <OverlayTrigger placement={this.props.placement} overlay={<Tooltip>{this.props.tooltip}</Tooltip>}>
          {this.props.children}
        </OverlayTrigger>
    );
  }
});