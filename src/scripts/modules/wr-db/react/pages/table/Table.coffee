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
    tables = WrDbStore.getTables(driver, configId)
    tableExportInfo = tables.find((tab) ->
      tab.get('id') == tableId)
    tableDbName = tableExportInfo?.get('name') or tableId
    isTableExportedValue = tableExportInfo?.get('export') or false
    isUpdatingTable = WrDbStore.isUpdatingTable(driver, configId, tableId)


    #state
    isUpdatingTable: isUpdatingTable
    tableConfig: tableConfig
    columns: tableConfig.get('columns')
    tableId: tableId
    configId: configId
    localState: localState
    tableDbName: tableDbName
    isTableExportedValue: isTableExportedValue

  render: ->
    console.log 'render tableConfig', @state.tableId, @state.tableConfig.toJS()
    div className: 'container-fluid kbc-main-content',
      div className: 'row kbc-header',
        div className: '',
          strong null, 'Database table name'
          ' '
          TableNameEdit
            tableId: @state.tableId
            table: @state.table
            configId: @state.configId
            tableExportedValue: @state.isTableExportedValue
            currentValue: @state.tableDbName
            isSaving: @state.isUpdatingTable
            editingValue: @state.localState?.getIn(['editingDbNames', @state.tableId])
            setEditValueFn: (value) =>
              path = ['editingDbNames', @state.tableId]
              @_updateLocalState(path, value)
            driver: driver
          ' '

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
