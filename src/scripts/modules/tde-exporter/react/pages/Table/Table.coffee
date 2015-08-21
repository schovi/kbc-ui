React = require 'react'
{fromJS, Map} = require 'immutable'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
StorageStore = require '../../../../components/stores/StorageTablesStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
ColumnsTable = require './ColumnsTable'
storageApi = require '../../../../components/StorageApi'

{button, i, strong, span, div, p, ul, li} = React.DOM
componentId = 'tde-exporter'

module.exports = React.createClass
  displayName: 'tabletde'
  mixins: [createStoreMixin(InstalledComponentsStore, StorageStore)]

  getInitialState: ->
    dataPreview: null

  componentDidMount: ->
    tableId = RoutesStore.getCurrentRouteParam('tableId')
    if not @state.columnsTypes?.count()
      table = StorageStore.getAll().find (t) ->
        t.get('id') == tableId
      columns = Map()
      table.get('columns').forEach (column) ->
        columns = columns.set(column, fromJS type: 'IGNORE')
      path = ['editing', tableId]
      @_updateLocalState(path, columns)


    component = @
    storageApi
    .exportTable tableId,
      limit: 10
    .then (csv) ->
      component.setState
        dataPreview: csv

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    tableId = RoutesStore.getCurrentRouteParam('tableId')
    configData = InstalledComponentsStore.getConfigData(componentId, configId)
    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    typedefs = configData.getIn(['parameters', 'typedefs'], Map()) or Map()
    isSaving = InstalledComponentsStore.getSavingConfigData(componentId, configId)

    table = StorageStore.getAll().find (table) ->
      table.get('id') == tableId
    columnsTypes = typedefs.get(tableId, Map())

    #state
    isSaving: isSaving
    configId: configId
    table: table
    columnsTypes: columnsTypes
    localState: localState
    tableId: tableId

  render: ->
    div className: 'container-fluid kbc-main-content',
      React.createElement ColumnsTable,
        table: @state.table
        columnsTypes: @state.columnsTypes
        dataPreview: @state.dataPreview
        editingData: @state.localState.getIn(['editing', @state.tableId])
        onChange: @_handleEditChange
        isSaving: @state.isSaving

  _handleEditChange: (data) ->
    path = ['editing', @state.tableId]
    @_updateLocalState(path, data)

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
