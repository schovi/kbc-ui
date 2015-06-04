React = require 'react'
_ = require 'underscore'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
Button = React.createFactory(require('react-bootstrap').Button)
Loader = React.createFactory(require('kbc-react-components').Loader)
Input = React.createFactory(require('react-bootstrap').Input)

{div, span, i, textarea} = React.DOM

StaticInput = React.createFactory React.createClass
  displayName: 'InlineEditAreaStatic'
  propTypes:
    text: React.PropTypes.string
    placeholder: React.PropTypes.string
    editTooltip: React.PropTypes.string
    onCancel: React.PropTypes.func

  render: ->
    props = _.omit @props, 'text'
    props.className = 'kbc-inline-edit-link'
    OverlayTrigger
      overlay: Tooltip null, @props.editTooltip
      placement: 'top'
    ,
      span props,
        if @props.text
          span null,
            @props.text
        else
          span className: 'text-muted',
            @props.placeholder
        ' '
        span className: 'kbc-icon-pencil'

EditInput = React.createFactory React.createClass
  displayName: 'InlineEditAreaEdit'
  propTypes:
    text: React.PropTypes.string
    isSaving: React.PropTypes.bool
    isValid: React.PropTypes.bool
    placeholder: React.PropTypes.string
    onCancel: React.PropTypes.func
    onSave: React.PropTypes.func
    onChange: React.PropTypes.func

  _onChange: (e) ->
    @props.onChange e.target.value

  componentDidMount: ->
    @refs.valueInput.getInputDOMNode().focus()

  render: ->
    div className: 'form-inline kbc-inline-edit',
      Input
        ref: 'valueInput'
        type: 'text'
        bsStyle: if !@props.isValid then 'error' else ''
        value: @props.text
        disabled: @props.isSaving
        placeholder: @props.placeholder
        onChange: @_onChange
      div className: 'kbc-inline-edit-buttons',
        Button
          className: 'kbc-inline-edit-cancel'
          bsStyle: 'link'
          disabled: @props.isSaving
          onClick: @props.onCancel
        ,
          span className: 'kbc-icon-cross2'
        Button
          className: 'kbc-inline-edit-submit'
          bsStyle: 'info'
          disabled: @props.isSaving || !@props.isValid
          onClick: @props.onSave
        ,
          'Save'
        if @props.isSaving
          span null,
            ' '
            Loader()




module.exports = React.createClass
  displayName: 'InlineEditTextInput'
  propTypes:
    onEditStart: React.PropTypes.func.isRequired
    onEditCancel: React.PropTypes.func.isRequired
    onEditChange: React.PropTypes.func.isRequired
    onEditSubmit: React.PropTypes.func.isRequired
    text: React.PropTypes.string
    isSaving: React.PropTypes.bool
    isEditing: React.PropTypes.bool
    isValid: React.PropTypes.bool

    editTooltip: React.PropTypes.string
    placeholder: React.PropTypes.string

  getDefaultProps: ->
    placeholder: 'Click to edit'
    editTooltip: 'Click to edit'
    isSaving: false

  render: ->
    if @props.isEditing
      EditInput
        text: @props.text
        isSaving: @props.isSaving
        isValid: @props.isValid
        placeholder: @props.placeholder
        onChange: @props.onEditChange
        onCancel: @props.onEditCancel
        onSave: @props.onEditSubmit
    else
      StaticInput
        text: @props.text
        editTooltip: @props.editTooltip
        placeholder: @props.placeholder
        onClick: @props.onEditStart

