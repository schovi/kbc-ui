React = require 'react'
{table, tr, th, tbody, thead, div, td} = React.DOM

module.exports = React.createClass

  displayName: 'ColumnsEditor'
  propTypes:
    staticColumns: React.PropTypes.object
    renderRowFn: React.PropTypes.func
    editingColumns: React.PropTypes.object
    editColumnFn: React.PropTypes.func
    dataTypes: React.PropTypes.array
    isSaving: React.PropTypes.bool
    allColumns: React.PropTypes.object
    filterColumnFn: React.PropTypes.func

  render: ->
    columns = @props.columns.filter( (c) =>
      if @props.editingColumns
        c = @props.editingColumns.get(c.get('name'))
      @props.filterColumnFn(c)
      )

    rows = columns.map((column) =>
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

    console.log rows.count()
    if rows.count() > 0
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
    else
      div className: 'well text-center', 'No Columns.'
