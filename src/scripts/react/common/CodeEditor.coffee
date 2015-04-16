React = require 'react'
CodeMirror = require 'react-code-mirror'
require('codemirror/mode/sql/sql')


module.exports = React.createClass
  displayName: 'CodeEditor'
  propTypes:
    value: React.PropTypes.string.isRequired
    readOnly: React.PropTypes.bool
    onChange: React.PropTypes.func
    mode: React.PropTypes.string

  getDefaultProps: ->
    mode: 'text/x-mysql'

  _handleChange: (e) ->
    @props.onChange
      value: e.target.value

  render: ->
    console.log 'props', @props
    React.createElement CodeMirror,
      value: @props.value
      theme: 'solarized'
      lineNumbers: true
      mode: @props.mode
      lineWrapping: false
      onChange: @_handleChange
      readOnly: @props.readOnly
      style:
        width: '100%'
        height: '90vh'
