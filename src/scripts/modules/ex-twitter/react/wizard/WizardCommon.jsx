import React, {PropTypes} from 'react';
import {TabbedArea} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    activeStep: PropTypes.string.isRequired,
    goToStep: PropTypes.func.isRequired,
    children: PropTypes.node
  },
  render() {
    return (
      <TabbedArea activeKey={this.props.activeStep} onSelect={this.props.goToStep} animation={false}>
        {this.mapChildren(this.props.children)}
      </TabbedArea>
    );
  },

  mapChildren(children) {
    const {goToStep} = this.props;
    return React.Children.map(children, (child) => {
      if (!child) {
        return child;
      }
      return React.cloneElement(child, {
        eventKey: child.props.step,
        tab: child.props.title,
        goToStep: goToStep
      });
    });
  }
});