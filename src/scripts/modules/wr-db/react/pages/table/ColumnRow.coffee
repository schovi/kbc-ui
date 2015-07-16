React = require 'react'
_ = require 'underscore'
{option, tr, td, div, span} = React.DOM
Check = React.createFactory(require('kbc-react-components').Check)
Input = React.createFactory(require('react-bootstrap').Input)

module.exports = React.createClass
  displayName: "WrColumnRow"
  propTypes:
    column: React.PropTypes.object
    editingColumn: React.PropTypes.object
    editColumnFn: React.PropTypes.func
    dataTypes: React.PropTypes.array
    isSaving: React.PropTypes.bool


  render: ->
    if @props.editingColumn
      @_renderEditing()
    else
      @_renderStatic()

  _renderEditing: ->
    tr null,
      td null, @props.column.get('name')
      td null, @_createInput('dbName')
      @_renderTypeSelect()

      td null, @_createInput('null', 'checkbox')
      td null, @_createInput('default')

  _renderTypeSelect: ->
    dtype = @props.editingColumn.get 'type'
    td null,
      Input
        type: 'select'
        value: dtype
        disabled: @props.isSaving
        onChange: (e) =>
          value = e.target.value
          newColumn = @props.editingColumn.set('type', value)
          if value == 'IGNORE'
            newColumn = newColumn.set('default', '')
          if value == 'VARCHAR'
            newColumn = newColumn.set('size', '255')
          if value == 'DECIMAL'
            newColumn = newColumn.set('size', '12,2')
          if value not in ['VARCHAR', 'DECIMAL']
            newColumn = newColumn.set('size', '')

          console.log newColumn.toJS()
          @props.editColumnFn(newColumn)
      ,
        @_selectOptions()
      @_createInput('size') if dtype in ['VARCHAR', 'DECIMAL']


  _selectOptions: ->
    _.map @props.dataTypes.concat('IGNORE'), (op) ->
      option
        value: op
        key: op
      ,
        op


  _createInput: (property, type = 'text') ->
    if @props.editingColumn.get('type') == 'IGNORE'
      return ''

    isChecked = @props.editingColumn.get(property) == '1'
    Input
      checked: isChecked
      type: type
      value: @props.editingColumn.get property
      disabled: @props.isSaving
      onChange: (e) =>
        newValue = e.target.value
        if type == 'checkbox'
          newValue = if e.target.checked then '1' else '0'
        newColumn = @props.editingColumn.set(property, newValue)
        @props.editColumnFn(newColumn)


  _renderStatic: ->
    tr null,
      td null, @props.column.get('name')
      td null, @props.column.get('dbName')
      @_renderType()
      @_renderNull()
      @_renderDefault()


  _renderDefault: ->
    val = @props.column.get 'default'
    if @_isIgnored()
      val = 'N/A'
    return td null, val


  _renderType: ->
    type = @props.column.get('type')
    size = @props.column.get('size')
    if size
      type = "#{type}(#{size})"
    return td null, type

  _renderNull: ->
    isChecked = @props.column.get('null') == '1'
    nullVal = Check({isChecked: isChecked})
    if @_isIgnored()
      nullVal = 'N/A'
    return td null, nullVal

  _isIgnored: ->
    @props.column.get('type') == 'IGNORE'
