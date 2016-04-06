React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
Input = React.createFactory(require('react-bootstrap').Input)
CodeMirror = React.createFactory(require('react-code-mirror'))

require('codemirror/addon/lint/lint')
require('../../../../utils/codemirror/json-lint')


{div, textarea} = React.DOM

TaskParametersEdit = React.createClass
  displayName: 'TaskParametersEdit'
  propTypes:
    parameters: React.PropTypes.object.isRequired
    onSet: React.PropTypes.func.isRequired

  getInitialState: ->
    parameters: @props.parameters
    parametersString: JSON.stringify @props.parameters, null, '\t'
    isValid: true

  getDefaultProps: ->
    isEditable: true

  renderJsonArea: ->
    CodeMirror
      theme: 'solarized'
      lineNumbers: true
      defaultValue: @state.parametersString
      readOnly: not @props.isEditable
      cursorHeight: 0 if not @props.isEditable
      height: 'auto'
      mode: 'application/json'
      lineWrapping: true
      autofocus: @props.isEditable
      onChange: @_handleChange
      lint: true
      gutters: ['CodeMirror-lint-markers']

  render: ->
    Modal title: 'Task parameters', onRequestHide: @props.onRequestHide,
      div className: 'modal-body', style: {padding: 0},
        @renderJsonArea()
      div className: 'modal-footer',
        if @props.isEditable
          ButtonToolbar null,
            Button
              bsStyle: 'link'
              onClick: @props.onRequestHide
            ,
              'Cancel'
            Button
              bsStyle: 'primary'
              disabled: !@state.isValid
              onClick: @_handleSet
            ,
              'Set'

  _handleChange: (e) ->
    @setState
      parametersString: e.target.value
    try
      @setState
        parameters: JSON.parse(e.target.value)
        isValid: true
    catch error
      @setState
        isValid: false

  _handleSet: ->
    @props.onRequestHide()
    @props.onSet @state.parameters

module.exports = TaskParametersEdit
