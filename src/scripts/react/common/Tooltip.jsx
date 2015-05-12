import React, {PropTypes} from 'react';
import {OverlayTrigger, Tooltip} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    tooltip: PropTypes.string.isRequired
  },

  render() {
    return (
        <OverlayTrigger overlay={<Tooltip>{this.props.tooltip}</Tooltip>}>
          <span>{this.props.children}</span>
        </OverlayTrigger>
    );
  }
});