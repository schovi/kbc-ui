React = require 'react'
_ = require 'underscore'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)

{div, span, i, textarea, button} = React.DOM

StaticArea = React.createFactory React.createClass
  displayName: 'InlineEditAreaStatic'
  propTypes:
    text: React.PropTypes.string
    placeholder: React.PropTypes.string
    editTooltip: React.PropTypes.string
    onCancel: React.PropTypes.func

  render: ->
    props = _.omit @props, 'text'
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
        i className: 'fa fa-edit text-muted'

EditArea = React.createFactory React.createClass
  displayName: 'InlineEditAreaEdit'
  propTypes:
    text: React.PropTypes.string
    placeholder: React.PropTypes.string
    onCancel: React.PropTypes.func
    onSave: React.PropTypes.func
    onChange: React.PropTypes.func

  _onChange: (e) ->
    @props.onChange e.target.value

  componentDidMount: ->
    @refs.textArea.getDOMNode().focus()

  render: ->
    div className: 'form-horizontal',
      div className: 'form-group',
        textarea(
          ref: 'textArea'
          value: @props.text
          placeholder: @props.placeholder
          onChange: @_onChange
          className: 'form-control'
        ),
      div className: 'form-group',
        div className: 'kbc-buttons',
          button
            className: 'btn btn-link'
            onClick: @props.onCancel
          ,
            'Cancel'
          button
            className: 'btn btn-primary'
            onClick: @props.onSave
          ,
            'Save'


module.exports = React.createClass
  displayName: 'InlineEditArea'
  propTypes:
    onSave: React.PropTypes.func.isRequired
    text: React.PropTypes.string
    editTooltip: React.PropTypes.string
    placeholder: React.PropTypes.string

  getDefaultProps: ->
    placeholder: 'Click to edit'
    editTooltip: 'Click to edit'

  getInitialState: ->
    isEditing: false
    editText: null

  _startEdit: ->
    @setState
      isEditing: true
      editText: @props.text

  _stopEdit: ->
    @setState
      isEditing: false

  _editChange: (newText) ->
    @setState
      editText: newText

  _save: ->
    @props.onSave @state.editText
    @setState
      isEditing: false


  render: ->
    if @state.isEditing
      EditArea
        text: @state.editText
        placeholder: @props.placeholder
        onChange: @_editChange
        onCancel: @_stopEdit
        onSave: @_save
    else
      StaticArea
        text: @props.text
        editTooltip: @props.editTooltip
        placeholder: @props.placeholder
        onClick: @_startEdit

