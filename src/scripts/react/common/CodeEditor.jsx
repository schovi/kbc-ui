import React from 'react';
import CodeMirror from 'react-code-mirror';
import 'codemirror/mode/sql/sql';
import 'codemirror/addon/display/placeholder';

export default React.createClass({
  propTypes: {
    value: React.PropTypes.string.isRequired,
    readOnly: React.PropTypes.bool,
    onChange: React.PropTypes.func,
    mode: React.PropTypes.string,
    placeholder: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      mode: 'text/x-mysql',
      placeholder: ''
    };
  },

  render() {
    return (
      <CodeMirror
        value={this.props.value}
        theme="solarized"
        lineNumbers={true}
        mode={this.props.mode}
        placeholder={this.props.placeholder}
        lineWrapping={false}
        onChange={this.handleChange}
        readOnly={this.props.readOnly}
        style={this.style()}
        />
    );
  },

  style() {
    return {
      width: '100%',
      height: '90vh'
    };
  },

  handleChange(e) {
    this.props.onChange({
      value: e.target.value
    });
  }

});