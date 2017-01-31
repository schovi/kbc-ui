import React, {PropTypes} from 'react/addons';
import {OverlayTrigger, Popover} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    title: PropTypes.string.isRequired,
    children: PropTypes.any.isRequired
  },
  mixins: [React.addons.PureRenderMixin],

  render() {
    return (
      <OverlayTrigger overlay={this.popover()}>
        <span className="fa fa-question-circle kbc-cursor-pointer"/>
      </OverlayTrigger>
    );
  },

  popover() {
    return (
      <Popover title={this.props.title}>
        {this.props.children}
      </Popover>
    );
  }
});