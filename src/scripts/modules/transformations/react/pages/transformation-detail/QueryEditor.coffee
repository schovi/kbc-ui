React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
Select = React.createFactory(require('react-select'))
_ = require('underscore')
Immutable = require('immutable')

require('codemirror/mode/sql/sql')
require('codemirror/mode/r/r')
CodeMirror = React.createFactory(require 'react-code-mirror')

module.exports = React.createClass
  displayName: 'QueryEditor'
  mixins: [ImmutableRenderMixin]

  propTypes:
    mode: React.PropTypes.string.isRequired
    value: React.PropTypes.string
    onChange: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired

  getDefaultProps: ->
    value: ''

  _handleOnChange: (e) ->
    @props.onChange(e.target.value)

  render: ->
    React.DOM.div {className: "edit"},
      CodeMirror
        value: @props.value
        theme: 'solarized'
        lineNumbers: true
        mode: @props.mode
        lineWrapping: true
        onChange: @_handleOnChange
        readOnly: @props.disabled
