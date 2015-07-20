/**
 * Fixes strange behaviour of react-autosuggest inside Modal
 * Issue: https://github.com/keboola/kbc-ui/issues/305
 * There must be some `setTimeout` call while rendering modal
 * http://stackoverflow.com/questions/28922275/in-reactjs-why-does-setstate-behave-differently-when-called-synchronously/28922465#28922465
 *
 */

import React, {PropTypes} from 'react';
import AutoSuggest from 'react-autosuggest';

export default React.createClass({
  propTypes: {
    suggestion: PropTypes.func.isRequired,
    onChange: PropTypes.func.isRequired,
    value: PropTypes.string.isRequired,
    id: PropTypes.string.isRequired,
    name: PropTypes.string.isRequired,
    placeholder: PropTypes.string.isRequired
  },

  getInitialState() {
    return ({
      value: this.props.value
    });
  },

  componentWillReceiveProps(nextProps) {
    if (nextProps.value !== this.state.value) {
      this.setState({
        value: nextProps.value
      });
    }
  },

  render() {
    return React.createElement(AutoSuggest, {
      suggestions: this.props.suggestions,
      inputAttributes: {
        onChange: this.handleChange,
        value: this.state.value,
        className: 'form-control',
        id: this.props.id,
        name: this.props.name,
        placeholder: this.props.placeholder
      }
    });
  },

  handleChange(newValue) {
    this.setState({
      value: newValue
    });
    this.props.onChange(newValue);
  }

});