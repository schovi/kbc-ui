import React, {PropTypes} from 'react';
import {TabPane} from 'react-bootstrap';

export default React.createClass({

  propTypes: {
    step: PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
    children: PropTypes.node,
    buttons: PropTypes.node
  },

  render() {
    return (
      <TabPane {...this.props} eventKey={this.props.step} tab={this.props.title}>
        <div className="row" style={this.style()}>
          {this.props.children}
        </div>
        <div className="kbc-row clearfix">
          <div className="pull-right">
            {this.props.buttons}
          </div>
        </div>
      </TabPane>
    );
  },

  style() {
    return {
      minHeight: '120px'
    };
  }

});