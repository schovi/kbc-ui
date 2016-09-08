React = require 'react'
_ = require 'underscore'

{fromJS, Map, List} = require('immutable')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

TableNameEdit = React.createFactory require './TableNameEdit'
ColumnsEditor = React.createFactory require './ColumnsEditor'
ColumnRow = require './ColumnRow'
DataTypes = require '../../../templates/dataTypes'

storageApi = require '../../../../components/StorageApi'

WrDbStore = require '../../../store'
WrDbActions = require '../../../actionCreators'
V2Actions = require('../../../v2-actions').default
RoutesStore = require '../../../../../stores/RoutesStore'
StorageTablesStore = require '../../../../components/stores/StorageTablesStore'
Input = React.createFactory(require('react-bootstrap').Input)

EditButtons = React.createFactory(require('../../../../../react/common/EditButtons'))
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
ActivateDeactivateButton = require('../../../../../react/common/ActivateDeactivateButton').default
InlineEditText = React.createFactory(require '../../../../../react/common/InlineEditTextInput')
PrimaryKeyModal = React.createFactory(require('./PrimaryKeyModal').default)
IsDockerBasedFn = require('../../../templates/dockerProxyApi').default

#componentId = 'wr-db'

#IGNORE is automatically included
#defaultDataTypes = ['INT','BIGINT', 'VARCHAR', 'TEXT', 'DECIMAL', 'DATE', 'DATETIME']
defaultDataTypes =
['INT','BIGINT',
'VARCHAR': {defaultSize: '255'},
'TEXT',
'DECIMAL': {defaultSize: '12,2'},
'DATE', 'DATETIME'
]

{option, select, label, input, p, ul, li, span, button, strong, div, i} = React.DOM


module.exports = (componentId) ->
  React.createClass templateFn(componentId)

templateFn = (componentId) ->
  displayName: "WrDbTableDetail"
  mixins: [createStoreMixin(WrDbStore, InstalledComponentsStore, StorageTablesStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    tableId = RoutesStore.getCurrentRouteParam('tableId')
    tableConfig = WrDbStore.getTableConfig(componentId, configId, tableId)
    storageTableColumns = StorageTablesStore.getAll().getIn [tableId, 'columns'], List()
    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    tablesExportInfo = WrDbStore.getTables(componentId, configId)
    exportInfo = tablesExportInfo.find((tab) ->
      tab.get('id') == tableId)
    isUpdatingTable = WrDbStore.isUpdatingTable(componentId, configId, tableId)
    editingData = WrDbStore.getEditing(componentId, configId)
    editingColumns = editingData.getIn ['columns', tableId]
    isSavingColumns = !!WrDbStore.getUpdatingColumns(componentId, configId, tableId)
    hideIgnored = localState.getIn ['hideIgnored', tableId], false
    v2Actions = V2Actions(configId, componentId)
    columnsValidation = editingData.getIn(['validation', tableId], Map())

    #state
    columnsValidation: columnsValidation
    hideIgnored: hideIgnored
    editingColumns: editingColumns
    editingData: editingData
    isUpdatingTable: isUpdatingTable
    tableConfig: tableConfig
    columns: @_prepareColumns(tableConfig.get('columns'), storageTableColumns)
    tableId: tableId
    configId: configId
    localState: localState
    exportInfo: exportInfo
    isSavingColumns: isSavingColumns
    v2Actions: v2Actions
    v2State: localState.get('v2', Map())
    v2ConfigTable: v2Actions.configTables.find((t) -> t.get('tableId') == tableId)

  getInitialState: ->
    dataPreview: null

  _prepareColumns: (configColumns, storageColumns) ->
    storageColumns.map (storageColumn) ->
      configColumnFound = configColumns.find( (cc) -> cc.get('name') == storageColumn)
      if configColumnFound
        configColumnFound
      else
        fromJS
          name: storageColumn
          dbName: storageColumn
          type: 'IGNORE'
          null: false
          default: ''
          size: ''

  componentDidMount: ->
    if @state.columns.reduce(
      (memo, value) ->
        memo and value.get('type') == 'IGNORE'
    , true)
      @_handleEditColumnsStart()
    tableId = RoutesStore.getCurrentRouteParam('tableId')
    component = @
    storageApi
    .exportTable tableId,
      limit: 10
    .then (csv) ->
      component.setState
        dataPreview: csv


  render: ->
    isRenderIncremental = IsDockerBasedFn(componentId) and componentId != 'wr-db-mssql'
    tableEditClassName = 'col-sm-12'
    if isRenderIncremental
      tableEditClassName = 'col-sm-7'
    div className: 'container-fluid kbc-main-content',
      div className: 'row kbc-table-editor-header',
        div className: tableEditClassName, @_renderTableEdit()
        if isRenderIncremental
          div className: 'col-sm-5', @_renderIncremetnalSetup()
        div className: 'col-sm-offset-7 col-sm-3',
          if !!@state.editingColumns
            @_renderSetColumnsType()
          else
            ' '
        div className: 'col-sm-2 kbc-buttons', @_renderEditButtons()

      ColumnsEditor
        onToggleHideIgnored: (e) =>
          path = ['hideIgnored', @state.tableId]
          @_updateLocalState(path, e.target.checked)
        dataTypes: DataTypes[componentId] or defaultDataTypes
        columns: @state.columns
        renderRowFn: @_renderColumnRow
        editingColumns: @state.editingColumns
        isSaving: @state.isSavingColumns
        editColumnFn: @_onEditColumn
        columnsValidation: @state.columnsValidation
        filterColumnsFn: @_hideIgnoredFilter
        filterColumnFn: @_filterColumn
        dataPreview: @state.dataPreview

  _setValidateColumn: (cname, isValid) ->
    path = ['validation', @state.tableId, cname]
    WrDbActions.setEditingData(componentId, @state.configId, path, isValid)

  _validateColumn: (column) ->
    type = column.get 'type'
    size = column.get 'size'
    dbName = column.get 'dbName'
    valid = true
    if _.isString(@_getSizeParam(type)) and _.isEmpty(size)
      valid = false
    if _.isEmpty(dbName)
      valid = false
    @_setValidateColumn(column.get('name'), valid)


  _renderIncremetnalSetup: ->
    exportInfo = @state.v2ConfigTable
    v2State = @state.v2State
    isIncremental = exportInfo.get('incremental')
    primaryKey = exportInfo.get('primaryKey', List())
    editingPkPath = @state.v2Actions.editingPkPath
    editingPk = v2State.getIn(editingPkPath)
    div null,
      strong null,
        'Incremental'
      React.createElement ActivateDeactivateButton,
        isActive: isIncremental
        activateTooltip: 'Set incremental'
        deactivateTooltip: 'reset incremental'
        isPending: @state.v2State.get('saving')
        buttonStyle: {'paddingTop': '0', 'paddingBottom': '0'}
        buttonDisabled: !!@state.editingColumns
        onChange: =>
          @setV2TableInfo(exportInfo.set('incremental', !isIncremental))
      strong null,
        'Primary Key'
      ' '
      button
        className: 'btn btn-link'
        style: {'paddingTop': 0, 'paddingBottom': 0}
        disabled: !!@state.editingColumns
        onClick: =>
          @state.v2Actions.updateV2State(editingPkPath, primaryKey)
        primaryKey.join(', ') or 'n/a'
        ' '
        span className: 'kbc-icon-pencil'
      PrimaryKeyModal
        tableConfig: @state.tableConfig
        columns: @state.columns.map (c) ->
          c.get('dbName')
        show: !!editingPk
        currentValue: primaryKey.join(',')
        isSaving: @state.v2State.get('saving')
        onHide: =>
          @state.v2Actions.updateV2State(editingPkPath, null)
        onSave: (newPk) =>
          @setV2TableInfo(exportInfo.set('primaryKey', newPk))

  _onEditColumn: (newColumn) ->
    cname = newColumn.get('name')
    path = ['columns', @state.tableId, cname]
    WrDbActions.setEditingData(componentId, @state.configId, path, newColumn)
    @_validateColumn(newColumn)

  _filterColumn: (column) ->
    not (column.get('type') == 'IGNORE' and @state.hideIgnored)

  _hideIgnoredFilter: (columns) ->
    if not columns
      return columns
    newCols = columns.filterNot (c) =>
      c.get('type') == 'IGNORE' and @state.hideIgnored
    newCols

  _renderColumnRow: (props) ->
    React.createElement ColumnRow, props


  _handleEditColumnsStart: ->
    path = ['columns', @state.tableId]
    columns = @state.columns.toMap().mapKeys (key, column) ->
      column.get 'name'
    WrDbActions.setEditingData(componentId, @state.configId, path, columns)

  _handleEditColumnsSave: ->
    #to preserve order remap according the original columns
    columns = @state.columns.map (c) =>
      @state.editingColumns.get(c.get('name'))
    WrDbActions.saveTableColumns(componentId, @state.configId, @state.tableId, columns).then =>
      @_handleEditColumnsCancel()

  _renderSetColumnsType: ->
    tmpDataTypes = @_getDataTypes()
    options = _.map tmpDataTypes.concat('IGNORE'), (opKey, opValue) ->
      option
        value: opKey
        key: opKey
      ,
        opKey
    span null,
      span null, 'Set All Columns To '
      select
        onChange: (e) =>
          value = e.target.value
          @state.editingColumns.map (ec) =>
            newColumn = ec.set 'type', value
            if _.isString @_getSizeParam(value)
              defaultSize = @_getSizeParam(value)
              newColumn = newColumn.set('size', defaultSize)
            else
              newColumn = newColumn.set('size', '')
            @_onEditColumn(newColumn)
        options

  _getSizeParam: (dataType) ->
    dtypes = DataTypes[componentId] or defaultDataTypes
    dt = _.find dtypes, (d) ->
      _.isObject(d) and _.keys(d)[0] == dataType
    result = dt?[dataType]?.defaultSize
    return result


  _getDataTypes: ->
    dtypes = DataTypes[componentId] or defaultDataTypes
    return _.map dtypes, (dataType) ->
      #it could be object eg {VARCHAR: {defaultSize:''}}
      if _.isObject dataType
        return _.keys(dataType)[0]
      else #or string
        return dataType

  _handleEditColumnsCancel: ->
    path = ['columns', @state.tableId]
    WrDbActions.setEditingData(componentId, @state.configId, path, null)
    @_clearValidation()

  _clearValidation: ->
    path = ['validation', @state.tableId]
    WrDbActions.setEditingData(componentId, @state.configId, path, Map())


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
          WrDbActions.setEditingData(componentId, @state.configId, path, value)
        componentId: componentId
      ' '

  _renderEditButtons: ->
    isValid = @state.columnsValidation?.reduce((memo, value) ->
      memo and value
    , true)
    hasColumns = @state.editingColumns?.reduce( (memo, c) ->
      type = c.get('type')
      type != 'IGNORE' or memo
    , false)
    div className: 'kbc-buttons pull-right',
      EditButtons
        isEditing: @state.editingColumns
        isSaving: @state.isSavingColumns
        isDisabled: not (isValid and hasColumns)
        onCancel: @_handleEditColumnsCancel
        onSave: @_handleEditColumnsSave
        onEditStart: @_handleEditColumnsStart
        editLabel: 'Edit Columns'

  setV2TableInfo: (newTableInfo) ->
    @state.v2Actions.setTableInfo(@state.tableId, newTableInfo)

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
