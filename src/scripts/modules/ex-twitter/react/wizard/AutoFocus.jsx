import React from 'react';

export default (Input) => {
  return React.createClass({
    propTypes: {
      currentStep: React.PropTypes.string.isRequired
    },

    componentDidMount() {
      this.triggerFocus();
    },

    componentDidUpdate(prevProps) {
      if (prevProps.currentStep !== this.props.currentStep) {
        this.triggerFocus();
      }
    },

    triggerFocus() {
      this.refs.input.getInputDOMNode().focus();
    },

    render() {
      return (
        <Input {...this.props} ref="input"/>
      );
    }
  });
};