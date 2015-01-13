React = require 'react'
ace = require('brace')
require 'brace/theme/github'
require 'brace/mode/mysql'

module.exports = React.createClass
  displayName: 'CodeEditor'
  propTypes:
    value: React.PropTypes.string.isRequired
    readOnly: React.PropTypes.bool
    onChange: React.PropTypes.func

  getDefaultProps: ->
    readOnly: false
    onChange: ->

  componentDidMount: ->
    editor = ace.edit(@getDOMNode())
    editor.getSession().setMode 'ace/mode/mysql'
    editor.setTheme 'ace/theme/github'
    editor.setValue @props.value
    editor.setReadOnly @props.readOnly
    editor.clearSelection()
    editor.getSession().on 'change', @_handleChange

    @editor = editor

  componentWillUnmount: ->
    @editor.destroy()

  _handleChange: ->
    @props.onChange
      value: @editor.getValue()

  render: ->
    React.DOM.div
      style:
        width: '100%'
        height: '400px'
    ,
      'ace editor'