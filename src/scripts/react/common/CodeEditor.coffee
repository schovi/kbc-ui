React = require 'react'
ace = require('brace')
require 'brace/theme/github'
require 'brace/mode/mysql'

module.exports = React.createClass
  displayName: 'CodeEditor'
  propTypes:
    value: React.PropTypes.string.isRequired

  componentDidMount: ->
    editor = ace.edit(@getDOMNode())
    editor.getSession().setMode 'ace/mode/mysql'
    editor.setTheme 'ace/theme/github'
    editor.setValue @props.value
    editor.setReadOnly true
    @editor = editor

  componentWillUnmount: ->
    @editor.destroy()

  render: ->
    React.DOM.div
      style:
        width: '100%'
        height: '400px'
    ,
      'ace editor'