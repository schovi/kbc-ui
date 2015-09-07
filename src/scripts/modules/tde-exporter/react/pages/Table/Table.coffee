React = require 'react'
{fromJS, Map} = require 'immutable'
_ = require 'underscore'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
StorageStore = require '../../../../components/stores/StorageTablesStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
ColumnsTable = require './ColumnsTable'
storageApi = require '../../../../components/StorageApi'

{label, input, select, option, button, i, strong, span, div, p, ul, li} = React.DOM
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

    #enforce empty Map(not List) workaround
    if _.isEmpty(columnsTypes?.toJS())
      columnsTypes = Map()

    #state
    isSaving: isSaving
    configId: configId
    table: table
    columnsTypes: columnsTypes
    localState: localState
    tableId: tableId

  render: ->
    isEditing = !!@state.localState.getIn(['editing', @state.tableId])
    div className: 'container-fluid kbc-main-content',
      div className: 'row kbc-table-editor-header',
        div className: 'col-sm-2', @_renderHideIngored()
        div className: 'col-sm-3',
          if isEditing
            @_renderSetColumnsType()
          else
            ' '
      React.createElement ColumnsTable,
        table: @state.table
        columnsTypes: @state.columnsTypes
        dataPreview: @state.dataPreview
        editingData: @state.localState.getIn(['editing', @state.tableId])
        onChange: @_handleEditChange
        isSaving: @state.isSaving
        hideIgnored: !! @state.localState.getIn ['hideIgnored', @state.tableId]


  _renderHideIngored: ->
    div className: 'checkbox',
      label className: '',
        input
          type: 'checkbox'
          label: 'Hide IGNORED'
          onChange: (e) =>
            path = ['hideIgnored', @state.tableId]
            @_updateLocalState(path, e.target.checked)

        ' Hide Ignored'


  _renderSetColumnsType: ->
    columnTdeTypes = ['string','boolean', 'number', 'decimal','date', 'datetime']
    defaults =
      date: "%Y-%m-%d"
      datetime: "%Y-%m-%d %H:%M:%S"

    options = _.map columnTdeTypes.concat('IGNORE').concat(''), (opKey, opValue) ->
      option
        value: opKey
        key: opKey
      ,
        opKey

    span null,
      span null, 'Set All Columns To '
      select
        defaultValue: ''
        onChange: (e) =>
          value = e.target.value
          if _.isEmpty(value)
            return
          @_prefillSelectedType(value)
        options
  _prefillSelectedType: (value) ->
    editingColumns = @_geteditingColumns()
    newColumns = editingColumns.map (ec) ->
      newColumn = ec.set 'type', value
      if value in _.keys(defaults)
        newColumn = newColumn.set('format', defaults[value])
      else
        newColumn = newColumn.set('format', null)
    @_handleEditChange(newColumns)

  _handleEditChange: (data) ->
    path = ['editing', @state.tableId]
    @_updateLocalState(path, data)

  _geteditingColumns: ->
    @state.localState.getIn(['editing', @state.tableId])

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
