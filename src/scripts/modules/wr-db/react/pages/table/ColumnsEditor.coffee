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
    dataPreview: React.PropTypes.array
    setValidationFn: React.PropTypes.func
    columnsValidation: React.PropTypes.object


  render: ->
    columns = @props.columns.filter( (c) =>
      if @props.editingColumns
        c = @props.editingColumns.get(c.get('name'))
      @props.filterColumnFn(c)
      )
    rows = columns.map((column) =>
      cname = column.get('name')
      editingColumn = null
      isValid = true
      if @props.editingColumns
        editingColumn = @props.editingColumns.get(cname)
        isValid = @props.columnsValidation.get(cname, true)

      @props.renderRowFn
        isValid: isValid
        setValidationFn: @props.setValidationFn
        isSaving: @props.isSaving
        column: column
        editingColumn: editingColumn
        dataTypes: @props.dataTypes
        editColumnFn: @props.editColumnFn
        dataPreview: @props.dataPreview
      )

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
