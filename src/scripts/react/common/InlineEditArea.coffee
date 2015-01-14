React = require 'react'
_ = require 'underscore'

{div, span, i, textarea, button} = React.DOM

StaticArea = React.createClass
  displayName: 'InlineEditAreaStatic'
  propTypes:
    text: React.PropTypes.string
    onCancel: React.PropTypes.func
  render: ->
    props = _.omit @props, 'text'
    div props,
      @props.text,
      i className: 'fa fa-edit'

EditArea = React.createClass
  displayName: 'InlineEditAreaEdit'
  propTypes:
    text: React.PropTypes.string
    onCancel: React.PropTypes.func
    onSave: React.PropTypes.func
    onChange: React.PropTypes.func

  _onChange: (e) ->
    @props.onChange e.target.value
  render: ->
    div null,
      textarea(
        value: @props.text
        onChange: @_onChange
        className: 'form-control'
      ),
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
        onChange: @_editChange
        onCancel: @_stopEdit
        onSave: @_save
    else
      StaticArea
        text: @props.text
        onClick: @_startEdit

