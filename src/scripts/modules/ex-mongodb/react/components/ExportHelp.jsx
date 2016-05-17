import React from 'react';
import {OverlayTrigger, Popover} from 'react-bootstrap';

export default React.createClass({

  render() {
    return (
      <p>
        <small>
          Help
          <OverlayTrigger placement="right" overlay={this.renderHint()}>
            <i className="fa fa-fw fa-question-circle"></i>
          </OverlayTrigger>
        </small>
      </p>
    );
  },

  renderHint() {
    return (
      <Popover title="Configuration" className="popover-wide">
        <ul>
          <li>Name has to be unique across all exports in current configuration</li>
          <li>Query, Sort and Mapping have to be valid JSON.</li>
        </ul>
      </Popover>
    );
  }

});
