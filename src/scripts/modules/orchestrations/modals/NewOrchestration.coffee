React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

OrchestrationActionCreators = require '../ActionCreators.coffee'

{div, p, strong, form, input, label} = React.DOM

NewOrchestration = React.createClass
  displayName: 'NewOrchestration'

  getInitialState: ->
    isLoading: false
    name: ''

  render: ->
    Modal title: "New Orchestration", onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        form className: 'form-horizontal',
          div className: 'form-group',
            label className: 'col-sm-4 control-label', 'Name'
            div className: 'col-sm-6',
              input className: 'form-control', value: @state.text, onChange: @_setName
      div className: 'modal-footer',
        ButtonToolbar null,
          Button onClick: @props.onRequestHide,
            'Cancel'
          Button bsStyle: 'primary', onClick: @_handleCreate, disabled: @state.isLoading,
            'Create'

  _handleCreate: ->

    @setState
      isLoading: true

    OrchestrationActionCreators.createOrchestration(
      name: @state.name
    ).then @props.onRequestHide

  _setName: (e) ->
    @setState
      name: e.target.value




module.exports = NewOrchestration