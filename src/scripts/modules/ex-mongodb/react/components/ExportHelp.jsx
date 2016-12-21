import React from 'react';
import {OverlayTrigger, Tooltip} from 'react-bootstrap';

export default React.createClass({

  propTypes: {
    message: React.PropTypes.string.isRequired
  },

  render() {
    return (
      <small>
        <OverlayTrigger placement="right" overlay={this.renderTooltip()}>
          <i className="fa fa-fw fa-question-circle" />
        </OverlayTrigger>
      </small>
    );
  },

  renderTooltip() {
    return (
      <Tooltip>
        {this.props.message}
      </Tooltip>
    );
  }

});
