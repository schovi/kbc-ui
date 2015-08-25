React = require 'react'
_ = require 'underscore'

{fromJS, Map, List} = require('immutable')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

TableNameEdit = React.createFactory require './TableNameEdit'
ColumnsEditor = React.createFactory require './ColumnsEditor'
ColumnRow = require './ColumnRow'
dataTypes = require '../../../templates/dataTypes'

storageApi = require '../../../../components/StorageApi'

WrDbStore = require '../../../store'
WrDbActions = require '../../../actionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'

Input = React.createFactory(require('react-bootstrap').Input)

EditButtons = React.createFactory(require('../../../../../react/common/EditButtons'))
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'

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
  mixins: [createStoreMixin(WrDbStore, InstalledComponentsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    tableId = RoutesStore.getCurrentRouteParam('tableId')
    tableConfig = WrDbStore.getTableConfig(componentId, configId, tableId)
    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    tablesExportInfo = WrDbStore.getTables(componentId, configId)
    exportInfo = tablesExportInfo.find((tab) ->
      tab.get('id') == tableId)
    isUpdatingTable = WrDbStore.isUpdatingTable(componentId, configId, tableId)
    editingData = WrDbStore.getEditing(componentId, configId)
    editingColumns = editingData.getIn ['columns', tableId]
    isSavingColumns = !!WrDbStore.getUpdatingColumns(componentId, configId, tableId)
    hideIgnored = localState.getIn ['hideIgnored', tableId], false

    columnsValidation = editingData.getIn(['validation', tableId], Map())

    #state
    columnsValidation: columnsValidation
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

  getInitialState: ->
    dataPreview: null


  componentDidMount: ->
    tableId = RoutesStore.getCurrentRouteParam('tableId')
    component = @
    storageApi
    .exportTable tableId,
      limit: 10
    .then (csv) ->
      component.setState
        dataPreview: csv


  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'row kbc-header',
        div className: 'col-sm-5', @_renderTableEdit()
        div className: 'col-sm-2', @_renderHideIngored()
        div className: 'col-sm-2',
          if !!@state.editingColumns
            @_renderSetColumnsType()
          else
            ' '
        div className: 'col-sm-3 kbc-buttons', @_renderEditButtons()

      ColumnsEditor
        dataTypes: dataTypes[componentId] or defaultDataTypes
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

  _renderHideIngored: ->
    label className: 'pull-right',
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
    WrDbActions.setEditingData(componentId, @state.configId, path, columns)

  _handleEditColumnsSave: ->
    #to preserve order remap according the original columns
    columns = @state.columns.map (c) =>
      @state.editingColumns.get(c.get('name'))
    WrDbActions.saveTableColumns(componentId, @state.configId, @state.tableId, columns).then =>
      @_handleEditColumnsCancel()

  _renderSetColumnsType: ->
    dataTypes = @_getDataTypes()
    options = _.map dataTypes.concat('IGNORE'), (opKey, opValue) ->
      option
        value: opKey
        key: opKey
      ,
        opKey
    span null,
      span null, 'Set All Coumns To'
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
    dtypes = dataTypes[componentId] or defaultDataTypes
    dt = _.find dtypes, (d) ->
      _.isObject(d) and _.keys(d)[0] == dataType
    result = dt?[dataType]?.defaultSize
    return result


  _getDataTypes: ->
    dtypes = dataTypes[componentId] or defaultDataTypes
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

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
