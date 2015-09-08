React = require 'react'
{Map} = require 'immutable'
{table, tr, th, tbody, thead, div, td} = React.DOM
ColumnRow = require './ColumnRow'
ComponentEmptyState = require '../../../../components/react/components/ComponentEmptyState'

module.exports = React.createClass
  displayName: 'ColumnsEditor'
  propTypes: ->
    table: React.PropTypes.object
    columnsTypes: React.PropTypes.object
    dataPreview: React.PropTypes.array
    editingData: React.PropTypes.object
    onChange: React.PropTypes.func
    filterColumnFn: React.PropTypes.func
    isSaving: React.PropTypes.bool

  render: ->
    isEditing = !! @props.editingData
    tableId = @props.table.get('id')
    columns = @props.table.get('columns')
    #filter ignored
    columns = columns.filterNot (c) =>
      typePath = [c, 'type']
      isStaticIgnored = not( !!@props.columnsTypes.getIn(typePath))
      isEditingIgnored = @props.editingData?.getIn(typePath) == 'IGNORE'
      if isEditing
        @props.hideIgnored and isEditingIgnored
      else
        @props.hideIgnored and isStaticIgnored

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
        table className: 'table table-striped kbc-table-layout-fixed kbc-table-editor',
          thead null,
            tr null,
              th style: {width: '35%'}, 'Column'
              th style: {width: '50%'}, 'TDE Data Type'
              th style: {width: '15%'}, 'Preview'
          tbody null,
            rows
    else
      React.createElement ComponentEmptyState, null,
        'No Columns.'
