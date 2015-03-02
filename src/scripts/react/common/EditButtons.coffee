###
  Edit buttons
  When editing Save and Cancel buttons are shown. These buttons are disabled and loader is shown when saving.
  Edit butotn is shown when editing mode is disabled.
###


React = require 'react'

Loader = require './Loader'
Button = require('react-bootstrap').Button

module.exports = React.createClass
  displayName: 'EditButtons'
  propTypes:
    isEditing: React.PropTypes.bool.isRequired
    isSaving: React.PropTypes.bool.isRequired
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

  render: ->
    if @props.isEditing
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
          disabled: @props.isSaving
          onClick: @props.onSave
        ,
          @props.saveLabel
    else
      React.DOM.div null,
        React.createElement Button,
          bsStyle: 'success'
          onClick: @props.onEditStart
        ,
          @props.editLabel
