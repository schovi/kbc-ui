React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ConfirmButtons = require '../../../../react/common/ConfirmButtons'

OrchestrationActionCreators = require '../../ActionCreators'

{div, p, strong, form, input, label} = React.DOM

NewOrchestration = React.createClass
  displayName: 'NewOrchestration'

  componentDidMount: ->
    @refs.name.getDOMNode().focus()

  getInitialState: ->
    isLoading: false
    isValid: false
    name: ''

  render: ->
    Modal title: "New Orchestration", onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        form className: 'form-horizontal',
          div className: 'form-group',
            label className: 'col-sm-4 control-label', 'Name'
            div className: 'col-sm-6',
              input
                placeholder: 'Orchestration name'
                className: 'form-control'
                value: @state.text
                onChange: @_setName
                ref: 'name'
      div className: 'modal-footer',
        React.createElement ConfirmButtons,
          isSaving: @state.isLoading
          isDisabled: !@state.isValid
          saveLabel: 'Create'
          onCancel: @props.onRequestHide
          onSave: @_handleCreate

  _handleCreate: ->
    @setState
      isLoading: true

    OrchestrationActionCreators.createOrchestration(
      name: @state.name
    ).then @props.onRequestHide

  _setName: (e) ->
    name = e.target.value.trim()
    @setState
      name: name
      isValid: name.length > 0




module.exports = NewOrchestration
