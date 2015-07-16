React = require 'react'

{fromJS, Map, List} = require('immutable')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

TableNameEdit = React.createFactory require './TableNameEdit'
ColumnsEditor = React.createFactory require './ColumnsEditor'
ColumnRow = require './ColumnRow'

WrDbStore = require '../../../store'
WrDbActions = require '../../../actionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'

EditButtons = React.createFactory(require('../../../../../react/common/EditButtons'))
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'

componentId = 'wr-db'
driver = 'mysql'

#IGNORE is automatically included
mysqlDataTypes = ['INT','BIGINT', 'VARCHAR', 'TEXT', 'DECIMAL', 'DATE', 'DATETIME']

{p, ul, li, span, button, strong, div, i} = React.DOM

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

    #state
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
        @_renderTableEdit()
        @_renderEditButtons()
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

  _renderEditButtons: ->
    div className: 'kbc-buttons',
      EditButtons
        isEditing: @state.editingColumns
        isSaving: @state.isSavingColumns
        isDisabled: false
        onCancel: @_handleEditColumnsCancel
        onSave: @_handleEditColumnsSave
        onEditStart: @_handleEditColumnsStart
        editLabel: 'Edit Columns'


  _renderColumnRow: (props) ->
    React.createElement ColumnRow, props

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

  _handleEditColumnsStart: ->
    path = ['columns', @state.tableId]
    columns = @state.columns.toMap().mapKeys (key, column) ->
      column.get 'name'
    WrDbActions.setEditingData(driver, @state.configId, path, columns)


  _handleEditColumnsSave: ->
    columns = @state.editingColumns.toList()
    console.log "COLUMNS TO SAVE", columns.toJS()
    WrDbActions.saveTableColumns(driver, @state.configId, @state.tableId, columns).then =>
      @_handleEditColumnsCancel()


  _handleEditColumnsCancel: ->
    path = ['columns', @state.tableId]
    WrDbActions.setEditingData(driver, @state.configId, path, null)


  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
