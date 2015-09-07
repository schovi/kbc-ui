React = require 'react'
_ = require 'underscore'
{table, tr, th, tbody, thead, div, span, td, option} = React.DOM
ColumnDataPreview = React.createFactory(require './ColumnDataPreview')

Input = React.createFactory(require('react-bootstrap').Input)

columnTdeTypes = ['string','boolean', 'number', 'decimal','date', 'datetime']
defaults =
  date: "%Y-%m-%d"
  datetime: "%Y-%m-%d %H:%M:%S"

###  FORMAT HINTS TODO
        <ul>
          <li>%Y – year (e.g. 2010)</li>
          <li>%m – month (01 - 12)</li>
          <li>%d – day (01 - 31)</li>
          <li>%I – hour (01 - 12)</li>
          <li>%H – hour 24 format (00 - 23)</li>
          <li>%M – minutes (00 - 59)</li>
          <li>%S – seconds (00 - 59)</li>
          <li>%f – microsecond as a decimal number, zero-padded on the left.(000000, 000001, ..., 999999)</li>
        </ul>

####


module.exports = React.createClass
  displayName: 'columnRow'
  propTypes:
    column: React.PropTypes.object
    tdeType: React.PropTypes.object
    editing: React.PropTypes.object
    dataPreview: React.PropTypes.array
    isSaving: React.PropTypes.bool
    onChange: React.PropTypes.func

  render: ->
    if @props.editing
      return @_renderEditing()
    tr null,
      td null, @props.column
      td null, @_renderStaticType()
      td null,
        ColumnDataPreview
          columnName: @props.column
          tableData: @props.dataPreview

  _renderStaticType: ->
    type = @props.tdeType.get('type') or 'IGNORE'
    format = @props.tdeType.get('format')
    if type in ['date', 'datetime']
      span null,
        "#{type} (#{format})"
    else
      span null, type

  _renderEditing: ->
    tr null,
      td null, @props.column
      td null, @_renderTypeSelect()
      td null,
        ColumnDataPreview
          columnName: @props.column
          tableData: @props.dataPreview


  _renderTypeSelect: ->
    dtype = @props.editing.get 'type'
    showFormat = dtype in ['date', 'datetime']
    span null,
      Input
        type: 'select'
        value: dtype
        disabled: @props.isSaving
        onChange: (e) =>
          value = e.target.value
          newData = @props.editing.set('type', value)
          if value not in ['date', 'datetime'] or value == 'IGNORE'
            newData = newData.delete('format')
          if value == 'date'
            newData = newData.set('format', defaults.date)
          if value == 'datetime'
            newData = newData.set('format', defaults.datetime)
          @props.onChange(newData)
      ,
        @_selectOptions()
      @_renderDatetFormatInput() if showFormat

  _renderDatetFormatInput: ->
    format = @props.editing.get 'format'
    Input
      type: 'text'
      bsSize: 'small'
      value: format
      disabled: @props.isSaving
      onChange: (e) =>
        newData = @props.editing.set('format', event.target.value)
        @props.onChange(newData)


  _selectOptions: ->
    dataTypes = columnTdeTypes
    _.map dataTypes.concat('IGNORE'), (opKey, opValue) ->
      option
        value: opKey
        key: opKey
      ,
        opKey
