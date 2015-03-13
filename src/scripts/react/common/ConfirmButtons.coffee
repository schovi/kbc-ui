###
  Edit buttons
  When editing Save and Cancel buttons are shown. These buttons are disabled and loader is shown when saving.
  Edit butotn is shown when editing mode is disabled.
###


React = require 'react'

Loader = require './Loader'
Button = require('react-bootstrap').Button

module.exports = React.createClass
  displayName: 'ConfirmButtons'
  propTypes:
    isSaving: React.PropTypes.bool.isRequired
    isDisabled: React.PropTypes.bool
    cancelLabel: React.PropTypes.string
    saveLabel: React.PropTypes.string
    onCancel: React.PropTypes.func.isRequired
    onSave: React.PropTypes.func.isRequired


  getDefaultProps: ->
    saveLabel: 'Save'
    cancelLabel: 'Cancel'
    isDisabled: false

  render: ->
    React.DOM.div className: 'kbc-buttons',
      if @props.isSaving
        React.createElement Loader
      React.createElement Button,
        bsStyle: 'link'
        disabled: @props.isSaving
        onClick: @props.onCancel
      ,
        @props.cancelLabel
      React.createElement Button,
        bsStyle: 'success'
        disabled: @props.isSaving || @props.isDisabled
        onClick: @props.onSave
      ,
        @props.saveLabel
