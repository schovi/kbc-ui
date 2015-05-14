import React from 'react';
import Typeahead from 'typeahead';

export default React.createClass({
  propTypes: {
    value: React.PropTypes.string.isRequired,
    options: React.PropTypes.array.isRequired,
    onChange: React.PropTypes.func.isRequired,
    placeholder: React.PropTypes.string
  },

  componentDidMount() {
    const input = this.refs.input.getDOMNode();
    Typeahead(this.refs.input.getDOMNode(), {
        source: this.props.options,
        position: 'below'
      });

    input.addEventListener('change', () => {
      this.props.onChange(input.value);
    });
  },

  render() {
    return (
      <input
        className="form-control"
        value={this.props.value}
        placeholder={this.props.placeholder}
        ref="input"
        onChange={this.onChange}
        />
    );
  },

  onChange(e) {
    this.props.onChange(e.target.value);
  }
});