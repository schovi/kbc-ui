###
  Edit buttons
  When editing Save and Cancel buttons are shown. These buttons are disabled and loader is shown when saving.
  Edit butotn is shown when editing mode is disabled.
###


React = require 'react'

ConfirmButtons = require('./ConfirmButtons').default
Button = require('react-bootstrap').Button

module.exports = React.createClass
  displayName: 'EditButtons'
  propTypes:
    isEditing: React.PropTypes.bool.isRequired
    isSaving: React.PropTypes.bool.isRequired
    isDisabled: React.PropTypes.bool
    editLabel: React.PropTypes.string
    cancelLabel: React.PropTypes.string
    saveLabel: React.PropTypes.string
    onCancel: React.PropTypes.func.isRequired
    onSave: React.PropTypes.func.isRequired
    onEditStart: React.PropTypes.func.isRequired

  getDefaultProps: ->
    editLabel: 'Edit'
    saveLabel: 'Save'
    cancelLabel: 'Cancel'
    isDisabled: false

  render: ->
    if @props.isEditing
      React.createElement ConfirmButtons,
        isSaving: @props.isSaving
        isDisabled: @props.isDisabled
        cancelLabel: @props.cancelLabel
        saveLabel: @props.saveLabel
        onCancel: @props.onCancel
        onSave: @props.onSave
    else
      React.DOM.span null,
        React.createElement Button,
          bsStyle: 'success'
          onClick: @props.onEditStart
        ,
          @props.editLabel
