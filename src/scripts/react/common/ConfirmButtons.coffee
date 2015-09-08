###
  Edit buttons
  When editing Save and Cancel buttons are shown. These buttons are disabled and loader is shown when saving.
  Edit butotn is shown when editing mode is disabled.
###


React = require 'react'

{Loader} = require 'kbc-react-components'
Button = require('react-bootstrap').Button

module.exports = React.createClass
  displayName: 'ConfirmButtons'
  propTypes:
    isSaving: React.PropTypes.bool.isRequired
    isDisabled: React.PropTypes.bool
    cancelLabel: React.PropTypes.string
    saveLabel: React.PropTypes.string
    saveStyle: React.PropTypes.string
    onCancel: React.PropTypes.func.isRequired
    onSave: React.PropTypes.func.isRequired
    placement: React.PropTypes.oneOf ['left', 'right']

  getDefaultProps: ->
    saveLabel: 'Save'
    saveStyle: 'success'
    cancelLabel: 'Cancel'
    placement: 'right'
    isDisabled: false

  render: ->
    if @props.placement == 'left'
      React.DOM.div className: 'kbc-buttons',
        @_saveButton()
        @_cancelButton()
        @_loader()
    else
      React.DOM.div className: 'kbc-buttons',
        @_loader()
        @_cancelButton()
        @_saveButton()

  _loader: ->
    if @props.isSaving
      React.createElement Loader

  _saveButton: ->
    React.createElement Button,
      bsStyle: @props.saveStyle
      disabled: @props.isSaving || @props.isDisabled
      onClick: @props.onSave
    ,
      @props.saveLabel

  _cancelButton: ->
    React.createElement Button,
      bsStyle: 'link'
      disabled: @props.isSaving
      onClick: @props.onCancel
    ,
      @props.cancelLabel