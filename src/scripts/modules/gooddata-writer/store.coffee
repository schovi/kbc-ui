
StoreUtils = require '../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../Dispatcher'
constants = require './constants'

{ColumnTypes} = constants
{Map, List} = Immutable


_store = Map
  writers: Map()
  tables: Map()
  tableColumns: Map()
  referenceableTables: Map()


modifyColumns =  (columns, newColumn, currentColumn) ->

  # reference changed
  if (newColumn.get('reference') != currentColumn.get('reference'))
    columns = columns.map (column) ->
      if column.get('sortLabel') == currentColumn.get('name')
        return column
        .delete('sortOrder')
        .delete('sortLabel')
      return column

  # schema reference changed
  if newColumn.get('schemaReference') != currentColumn.get('schemaReference')
    columns = columns.map (column) ->
      return column if column.get('name') == newColumn.get('name')
      if column.get('schemaReference') == newColumn.get('schemaReference')
        return column.delete('schemaReference')
      return column


  # column type changed
  if newColumn.get('type') != currentColumn.get('type')
    columns = columns.map (column) ->
      return column if column.get('name') == newColumn.get('name')

      isNotReferencable = [ColumnTypes.CONNECTION_POINT, ColumnTypes.ATTRIBUTE].indexOf(newColumn.get('type')) < 0
      if column.get('reference') == newColumn.get('name') && isNotReferencable
        return column.delete('reference')
      return column

  columns

###

###
validateColumns = (columns) ->
  columns
  .filter (column) ->
    # empty name
    return true if column.get('gdName').trim() == ''

    # reference not set
    if [ColumnTypes.LABEL, ColumnTypes.HYPERLINK].indexOf(column.get('type')) >= 0
      return true if !column.get('reference')

    # schema reference not set
    return true if column.get('type') == ColumnTypes.REFERENCE && !column.get('schemaReference')

    false
  .map (column) ->
    column.get('name')




GoodDataWriterStore = StoreUtils.createStore


  hasWriter: (configurationId) ->
    _store.hasIn ['writers', configurationId]

  hasTableColumns: (configurationId, tableId) ->
    _store.hasIn ['tableColumns', configurationId, tableId, 'current']

  getWriter: (configurationId) ->
    _store.getIn ['writers', configurationId]

  getReferenceableTables: (configurationId) ->
    _store.getIn ['referenceableTables', configurationId]

  getWriterTablesByBucket: (configurationId) ->
    _store
    .getIn(['tables', configurationId])
    .toSeq()
    .groupBy (table) ->
      table.getIn ['data', 'bucket']

  getTable: (configurationId, tableId) ->
    _store.getIn ['tables', configurationId, tableId]

  getTableColumns: (configurationId, tableId, version = 'current') ->
    _store.getIn ['tableColumns', configurationId, tableId, version]

  getTableColumnsValidation: (configurationId, tableId) ->
    _store.getIn ['tableColumns', configurationId, tableId, 'invalidColumns'], List()

  isEditingTableColumns: (configurationId, tableId) ->
    _store.hasIn ['tableColumns', configurationId, tableId, 'editing']

  isSavingTableColumns: (configurationId, tableId) ->
    _store.hasIn ['tableColumns', configurationId, tableId, 'isSaving']

dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_START
      _store = _store.setIn ['writers', action.configurationId, 'isLoading'], true
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_ERROR
      _store = _store.setIn ['writers', action.configurationId, 'isLoading'], false
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_SUCCESS
      tablesById = Immutable
      .fromJS(action.configuration.tables)
      .toMap()
      .map (table) ->
        Map
          isLoading: false
          id: table.get 'id'
          pendingActions: List()
          data: table
      .mapKeys (key, table) ->
        table.get 'id'

      _store = _store.withMutations (store) ->
        store
        .setIn ['writers', action.configuration.id, 'isLoading'], false
        .setIn ['writers', action.configuration.id, 'config'], Immutable.fromJS action.configuration.writer
        .setIn ['tables', action.configuration.id], tablesById
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_TABLE_EXPORT_STATUS_CHANGE_START
      _store = _store.updateIn ['tables', action.configurationId, action.tableId, 'pendingActions'], (actions) ->
        actions.push 'exportStatusChange'
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_TABLE_EXPORT_STATUS_CHANGE_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .setIn ['tables', action.configurationId, action.tableId, 'data', 'export'], action.newExportStatus
        .updateIn ['tables', action.configurationId, action.tableId, 'pendingActions'], (actions) ->
          actions.delete(actions.indexOf 'exportStatusChange')
      console.log 'store', _store.toJS()
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_TABLE_EXPORT_STATUS_CHANGE_ERROR
      _store = _store.updateIn ['tables', action.configurationId, action.tableId, 'pendingActions'], (actions) ->
        actions.delete(actions.indexOf 'exportStatusChange')
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_TABLE_SUCCESS
      console.log 'referenceable tables', action.referenceableTables
      table = Immutable.fromJS(action.table)
        .set 'bucket', action.table.id.split('.',2).join('.') # bucket is not returned by api

      columns = table.get('columns').toMap().mapKeys (key, column) ->
        column.get 'name'

      _store = _store.withMutations (store) ->
        store
        .setIn ['tables', action.configurationId, table.get('id'), 'data'], table.remove('columns')
        .setIn ['tableColumns', action.configurationId, table.get('id'), 'current'], columns
      GoodDataWriterStore.emitChange()


    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_REFERENCABLE_TABLES_SUCCESS
      _store = _store.setIn ['referenceableTables', action.configurationId], Immutable.fromJS(action.tables)
      GoodDataWriterStore.emitChange()


    when constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_START
      _store = _store.setIn ['tableColumns', action.configurationId, action.tableId, 'editing'],
        _store.getIn ['tableColumns', action.configurationId, action.tableId, 'current']
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_CANCEL
      _store = _store.deleteIn ['tableColumns', action.configurationId, action.tableId, 'editing']
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_UPDATE
      currentColumn = _store.getIn [
        'tableColumns'
        action.configurationId
        action.tableId
        'editing'
        action.column.get 'name'
      ]

      _store = _store.updateIn [
        'tableColumns'
        action.configurationId
        action.tableId

      ], (tableColumns) ->
        columns = tableColumns.get('editing')
        columns = columns.set action.column.get('name'), action.column
        columns = modifyColumns columns, action.column, currentColumn

        invalidColumns = validateColumns columns

        tableColumns
        .set 'editing', columns
        .set 'invalidColumns', invalidColumns

      GoodDataWriterStore.emitChange()


    when constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_SAVE_START
      _store = _store.setIn [
        'tableColumns'
        action.configurationId
        action.tableId
        'isSaving'
      ], true
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_SAVE_ERROR
      _store = _store.deleteIn [
        'tableColumns'
        action.configurationId
        action.tableId
        'isSaving'
      ]
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_SAVE_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .deleteIn([
          'tableColumns'
          action.configurationId
          action.tableId
          'editing'
        ])
        .deleteIn([
          'tableColumns'
          action.configurationId
          action.tableId
          'isSaving'
        ])
        .setIn([
          'tableColumns'
          action.configurationId
          action.tableId
          'current'
        ], Immutable.fromJS(action.columns))

      GoodDataWriterStore.emitChange()

module.exports = GoodDataWriterStore