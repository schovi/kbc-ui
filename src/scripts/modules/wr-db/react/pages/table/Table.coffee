React = require 'react'


{fromJS, Map, List} = require('immutable')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

TableNameEdit = React.createFactory require './TableNameEdit'
ColumnsEditor = React.createFactory require './ColumnsEditor'
ColumnRow = require './ColumnRow'


WrDbStore = require '../../../store'
WrDbActions = require '../../../actionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'

Input = React.createFactory(require('react-bootstrap').Input)

EditButtons = React.createFactory(require('../../../../../react/common/EditButtons'))
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'

componentId = 'wr-db'
driver = 'mysql'

#IGNORE is automatically included
mysqlDataTypes = ['INT','BIGINT', 'VARCHAR', 'TEXT', 'DECIMAL', 'DATE', 'DATETIME']

{label, input, p, ul, li, span, button, strong, div, i} = React.DOM

module.exports = React.createClass
  displayName: "WrDbTableDetail"
  mixins: [createStoreMixin(WrDbStore, InstalledComponentsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    tableId = RoutesStore.getCurrentRouteParam('tableId')
    tableConfig = WrDbStore.getTableConfig(driver, configId, tableId)
    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    tablesExportInfo = WrDbStore.getTables(driver, configId)
    exportInfo = tablesExportInfo.find((tab) ->
      tab.get('id') == tableId)
    isUpdatingTable = WrDbStore.isUpdatingTable(driver, configId, tableId)
    editingData = WrDbStore.getEditing(driver, configId)
    editingColumns = editingData.getIn ['columns', tableId]
    isSavingColumns = !!WrDbStore.getUpdatingColumns(driver, configId, tableId)
    hideIgnored = localState.getIn ['hideIgnored', tableId], false

    #state
    hideIgnored: hideIgnored
    editingColumns: editingColumns
    editingData: editingData
    isUpdatingTable: isUpdatingTable
    tableConfig: tableConfig
    columns: tableConfig.get('columns')
    tableId: tableId
    configId: configId
    localState: localState
    exportInfo: exportInfo
    isSavingColumns: isSavingColumns


  render: ->
    console.log 'render table', @state.tableId, @state.tableConfig.toJS(), "EDITING DATA", @state.editingData.toJS()

    div className: 'container-fluid kbc-main-content',
      div className: 'row kbc-header',
        div className: 'col-sm-12',
          div className: 'col-sm-5', @_renderTableEdit()
          div className: 'col-sm-2', @_renderHideIngored()
          div className: 'col-sm-5', @_renderEditButtons()

      ColumnsEditor
        dataTypes: mysqlDataTypes
        columns: @state.columns
        renderRowFn: @_renderColumnRow
        editingColumns: @state.editingColumns
        isSaving: @state.isSavingColumns
        editColumnFn: (newColumn) =>
          cname = newColumn.get('name')
          path = ['columns', @state.tableId, cname]
          WrDbActions.setEditingData(driver, @state.configId, path, newColumn)
        filterColumnsFn: @_hideIgnoredFilter
        filterColumnFn: @_filterColumn

  _filterColumn: (column) ->
    not (column.get('type') == 'IGNORE' and @state.hideIgnored)

  _hideIgnoredFilter: (columns) ->
    if not columns
      return columns
    newCols = columns.filterNot (c) =>
      c.get('type') == 'IGNORE' and @state.hideIgnored
    newCols

  _renderHideIngored: ->
    label null,
      input
        type: 'checkbox'
        label: 'Hide IGNORED'
        onChange: (e) =>
          path = ['hideIgnored', @state.tableId]
          @_updateLocalState(path, e.target.checked)

      ' Hide Ignored'


  _renderColumnRow: (props) ->
    React.createElement ColumnRow, props


  _handleEditColumnsStart: ->
    path = ['columns', @state.tableId]
    columns = @state.columns.toMap().mapKeys (key, column) ->
      column.get 'name'
    WrDbActions.setEditingData(driver, @state.configId, path, columns)

  _handleEditColumnsSave: ->
    #to preserve order remap according the original columns
    columns = @state.columns.map (c) =>
      @state.editingColumns.get(c.get('name'))
    WrDbActions.saveTableColumns(driver, @state.configId, @state.tableId, columns).then =>
      @_handleEditColumnsCancel()


  _handleEditColumnsCancel: ->
    path = ['columns', @state.tableId]
    WrDbActions.setEditingData(driver, @state.configId, path, null)

  _renderTableEdit: ->
    div className: '',
      strong null, 'Database table name'
      ' '
      TableNameEdit
        tableId: @state.tableId
        table: @state.table
        configId: @state.configId
        tableExportedValue: @state.exportInfo?.get('export') or false
        currentValue: @state.exportInfo?.get('name') or @state.tableId
        isSaving: @state.isUpdatingTable
        editingValue: @state.editingData.getIn(['editingDbNames', @state.tableId])
        setEditValueFn: (value) =>
          path = ['editingDbNames', @state.tableId]
          WrDbActions.setEditingData(driver, @state.configId, path, value)
        driver: driver
      ' '

  _renderEditButtons: ->
    div className: 'kbc-buttons pull-right',
      EditButtons
        isEditing: @state.editingColumns
        isSaving: @state.isSavingColumns
        isDisabled: false
        onCancel: @_handleEditColumnsCancel
        onSave: @_handleEditColumnsSave
        onEditStart: @_handleEditColumnsStart
        editLabel: 'Edit Columns'

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
