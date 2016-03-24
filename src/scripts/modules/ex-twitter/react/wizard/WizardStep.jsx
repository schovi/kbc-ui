import React, {PropTypes} from 'react';
import {TabPane} from 'react-bootstrap';

export default React.createClass({

  propTypes: {
    step: PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
    children: PropTypes.node
  },

  render() {
    return (
      <TabPane {...this.props} eventKey={this.props.step} tab={this.props.title}>
        {this.props.children}
      </TabPane>
    );
  }

});