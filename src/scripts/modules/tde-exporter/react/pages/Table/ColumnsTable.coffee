React = require 'react'
{Map} = require 'immutable'
{table, tr, th, tbody, thead, div, td} = React.DOM
ColumnRow = require './ColumnRow'

module.exports = React.createClass
  displayName: 'ColumnsEditor'
  propTypes: ->
    table: React.PropTypes.object
    columnsTypes: React.PropTypes.object
    dataPreview: React.PropTypes.array
    editingData: React.PropTypes.object
    onChange: React.PropTypes.func
    isSaving: React.PropTypes.bool

  render: ->
    console.log 'render', @props.editingData?.toJS()
    tableId = @props.table.get('id')
    columns = @props.table.get('columns')

    rows = columns.map (column) =>
      editingColumn = @props.editingData?.get(column)
      React.createElement ColumnRow,
        column: column
        tdeType: @props.columnsTypes.get(column, Map())
        editing: editingColumn
        isSaving: @props.isSaving
        dataPreview: @props.dataPreview
        onChange: (data) =>
          newData = @props.editingData.set(column, data)
          @props.onChange(newData)

    if rows.count() > 0
      div style: {overflow: 'scroll'},
        table className: 'table table-striped kbc-table-editor',
          thead null,
            tr null,
              th null, 'KB Storage Column'
              th null, 'TDE Data Type'
              th null, 'Preview'
          tbody null,
            rows
    else
      div className: 'well text-center', 'No Columns.'
