React = require 'react'
{fromJS, Map} = require 'immutable'
_ = require 'underscore'
tdeCommon = require '../../../tdeCommon'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
StorageStore = require '../../../../components/stores/StorageTablesStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
InlineEditText = React.createFactory(require '../../../../../react/common/InlineEditTextInput')
ColumnsTable = require './ColumnsTable'
storageApi = require '../../../../components/StorageApi'
{Input, FormControls} = require 'react-bootstrap'
StaticText = FormControls.Static
{label, input, select, option, button, i, strong, span, div, p, ul, li} = React.DOM

columnTdeTypes = ['string','boolean', 'number', 'decimal','date', 'datetime']
defaults =
  date: "%Y-%m-%d"
  datetime: "%Y-%m-%d %H:%M:%S"

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

    #tde filename
    tdeFileName = tdeCommon.getTdeFileName(configData || Map(), tableId)
    editingTdeFileName = tdeCommon.getEditingTdeFileName(configData, localState, tableId)

    #state
    isSaving: isSaving
    configId: configId
    table: table
    columnsTypes: columnsTypes
    localState: localState
    tableId: tableId
    tdeFileName: tdeFileName
    editingTdeFileName: editingTdeFileName

  render: ->
    isEditing = !!@state.localState.getIn(['editing', @state.tableId])
    div className: 'container-fluid kbc-main-content',
      div className: 'row kbc-header',
        div className: 'col-sm-3', @_renderHideIngored()
        div className: 'col-sm-4', @_renderOutNameEditor(isEditing)
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

  _renderOutNameEditor: (isEditing) ->
    tlabel = 'Output file name:'
    if not isEditing
      React.createElement StaticText,
        label: tlabel
        bsSize: 'small'
        wrapperClassName: 'wrapper'
      ,
        @state.tdeFileName
    else
      errorMsg = tdeCommon.assertTdeFileName(@state.editingTdeFileName)
      React.createElement Input,
        value: @state.editingTdeFileName
        bsSize: 'small'
        bsStyle: if errorMsg then 'error' else ''
        help: errorMsg
        type: 'text'
        label: tlabel
        wrapperClassName: 'wrapper'
        onChange: (e) =>
          value = e.target.value
          path = ['editingTdeNames', @state.tableId]
          @_updateLocalState(path, value)



  _renderHideIngored: ->
    React.createElement Input,
      style: {padding: '0'}
      type: 'checkbox'
      label: 'Hide IGNORED'
      #labelClassName: 'col-xs-10'
      #wrapperClassName: 'col-xs-12'
      onChange: (e) =>
        path = ['hideIgnored', @state.tableId]
        @_updateLocalState(path, e.target.checked)

  _renderSetColumnsType: ->
    options = _.map columnTdeTypes.concat('IGNORE').concat(''), (opKey, opValue) ->
      option
        value: opKey
        key: opKey
      ,
        opKey

    React.createElement Input,
      type: 'select'
      label: 'Set All Columns To '
      bsSize: 'small'
      placeholder: 'select TDE data type'
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
