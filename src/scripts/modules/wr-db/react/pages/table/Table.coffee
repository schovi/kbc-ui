React = require 'react'

{fromJS, Map, List} = require('immutable')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

TableNameEdit = React.createFactory require './TableNameEdit'

WrDbStore = require '../../../store'
WrDbActions = require '../../../actionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'

InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'

componentId = 'wr-db'
driver = 'mysql'

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

    #state
    editingData: editingData
    isUpdatingTable: isUpdatingTable
    tableConfig: tableConfig
    columns: tableConfig.get('columns')
    tableId: tableId
    configId: configId
    localState: localState
    exportInfo: exportInfo


  render: ->
    console.log 'render table', @state.tableId, @state.tableConfig.toJS(), "EDITING DATA", @state.editingData.toJS()
    div className: 'container-fluid kbc-main-content',
      div className: 'row kbc-header',
        @_renderTableEdit()


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

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
