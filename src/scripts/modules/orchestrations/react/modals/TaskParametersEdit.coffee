React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

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

  render: ->
    Modal title: 'Task parameters edit', onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        textarea
          className: 'form-control'
          value: @state.parametersString
          onChange: @_handleChange
      div className: 'modal-footer',
        ButtonToolbar null,
          Button
            bsStyle: 'default'
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