React = require 'react'
{table, tr, th, tbody, thead, div, td} = React.DOM

module.exports = React.createClass

  displayName: 'ColumnsEditor'
  propTypes:
    columns: React.PropTypes.object
    renderRowFn: React.PropTypes.func
    editingColumns: React.PropTypes.object
    editColumnFn: React.PropTypes.func
    dataTypes: React.PropTypes.array
    isSaving: React.PropTypes.bool

  render: ->
    rows = @props.columns.map((column) =>
      cname = column.get('name')
      editingColumn = null
      if @props.editingColumns
        editingColumn = @props.editingColumns.get(cname)
      @props.renderRowFn
        isSaving: @props.isSaving
        column: column
        editingColumn: editingColumn
        dataTypes: @props.dataTypes
        editColumnFn: @props.editColumnFn
      )

    div style: {overflow: 'scroll'},
      table className: 'table table-striped kbc-table-editor',
        thead null,
          tr null,
            th null, 'KB Storage Column'
            th null, 'Database Column Name'
            th null, 'Data Type'
            th null, 'NULL'
            th null, 'Default Value'
            th null
        tbody null,
          rows
