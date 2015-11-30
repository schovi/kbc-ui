StoreUtils = require '../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../Dispatcher'
constants = require './constants'
fuzzy = require 'fuzzy'

{ColumnTypes, DataTypes} = constants
{Map, List} = Immutable


_store = Map
  writers: Map()
  tables: Map()
  tableColumns: Map()
  filters: Map() # by [writer_id][tables] = value
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

  # data type changed
  if newColumn.get('dataType') != currentColumn.get('dataType')
    columns = columns.update newColumn.get('name'), (column) ->
      switch column.get('dataType')
        when DataTypes.VARCHAR then column.set 'dataTypeSize',  '255'
        when DataTypes.DECIMAL then column.set 'dataTypeSize', '12,2'
        else column.set 'dataTypeSize', null

  # column type changed
  if newColumn.get('type') != currentColumn.get('type')
    columns = columns.map (column) ->
      if column.get('name') == newColumn.get('name')
        columnDefaults =
          dataType: null
          dataTypeSize: null
          reference: null
          schemaReference: null
          format: null
          dateDimension: null
          sortLabel: null
          sortOrder: null
        column = column
          .merge(Map(columnDefaults))
          .set('type', newColumn.get('type'))

        if column.get('type') == ColumnTypes.DATE
          column = column.set('format', 'yyyy-MM-dd HH:mm:ss')

        return column

      # reset references if column becomes non-referenceable
      isNotReferencable = [ColumnTypes.CONNECTION_POINT, ColumnTypes.ATTRIBUTE].indexOf(newColumn.get('type')) < 0
      if column.get('reference') == newColumn.get('name') && isNotReferencable
        return column.delete('reference')

      # allow only one connection point for table
      if newColumn.get('type') == ColumnTypes.CONNECTION_POINT && column.get('type') == ColumnTypes.CONNECTION_POINT
        column = column.set('type', ColumnTypes.ATTRIBUTE)

      return column

  columns

###

###
getInvalidColumns = (columns) ->
  columns
  .filter (column) ->
    # empty name
    return true if column.get('title').trim() == ''

    # reference not set
    if [ColumnTypes.LABEL, ColumnTypes.HYPERLINK].indexOf(column.get('type')) >= 0
      return true if !column.get('reference')

    # schema reference not set
    return true if column.get('type') == ColumnTypes.REFERENCE && !column.get('schemaReference')

    # format and dateDimension not set for DATE type
    return true if column.get('type') == ColumnTypes.DATE && !(column.get('format') && column.get('dateDimension'))

    false
  .map (column) ->
    column.get('name')


referenceableColumnFilter = (currentColumnName) ->
  (column) ->
    return false if column.get('name') == currentColumnName
    return true if [ColumnTypes.CONNECTION_POINT, ColumnTypes.ATTRIBUTE].indexOf(column.get('type')) >= 0
    return false

sortLabelColumnFilter = (currentColumnName) ->
  (column) ->
    currentColumnName == column.get('reference')


referencesForColumns = (columns) ->
  columns.map (column) ->
    refColumns = columns.filter(referenceableColumnFilter(column.get 'name')).map (column) -> column.get('name')
    sortColumns = columns.filter(sortLabelColumnFilter(column.get 'name')).map (column) -> column.get('name')
    Map(
      referenceableColumns: refColumns
      sortColumns: sortColumns
    )

extendTable = (table) ->
  if not table.has('id')
    table = table.set('id', table.get('tableId')) #ui fallback to id

  table = table.set('sapiName', table.get('id').replace(table.get('bucket') + '.', ''))
  if !table.get('name')?.length
    table = table.set('name', table.get('id')) # fallback to table id if name not set

  if !table.get('title')?.length
    table = table.set('title', table.get('id'))
  table

GoodDataWriterStore = StoreUtils.createStore


  hasWriter: (configurationId) ->
    _store.hasIn ['writers', configurationId, 'config']

  hasTableColumns: (configurationId, tableId) ->
    _store.hasIn ['tableColumns', configurationId, tableId, 'current']

  getWriter: (configurationId) ->
    _store.getIn ['writers', configurationId]

  isNewWriter: (configurationId) ->
    @getWriter(configurationId).getIn(['config', 'feats', 'new_config'], false)

  getWriterTablesFilter: (configurationId) ->
    _store.getIn ['filters', configurationId, 'tables'], ''

  getReferenceableTablesForTable: (configurationId, tableId) ->
    _store.getIn(['referenceableTables', configurationId]).filter (name, id) ->
      id != tableId

  getWriterTablesByBucket: (configurationId) ->
    _store
    .getIn(['tables', configurationId])
    .toSeq()
    #.groupBy (table) ->
    #  table.getIn ['data', 'bucket']

  getWriterTablesByBucketFiltered: (configurationId) ->
    filter = @getWriterTablesFilter configurationId

    all = @getWriterTablesByBucket(configurationId)
    return all if !filter

    all
    .map (tables) ->
      tables.filter (table) ->
        fuzzy.match(filter, table.getIn ['data', 'name'])
    .filter (tables) ->
      tables.count() > 0


  getTable: (configurationId, tableId) ->
    _store.getIn ['tables', configurationId, tableId]

  getTableColumns: (configurationId, tableId, version = 'current') ->
    _store.getIn ['tableColumns', configurationId, tableId, version]

  getTableColumnsValidation: (configurationId, tableId) ->
    _store.getIn ['tableColumns', configurationId, tableId, 'invalidColumns'], List()

  getTableColumnsReferences: (configurationId, tableId) ->
    _store.getIn ['tableColumns', configurationId, tableId, 'references'], Map(
      referenceableColumns: Map()
      sortColumns: Map()
    )

  isEditingTableColumns: (configurationId, tableId) ->
    _store.hasIn ['tableColumns', configurationId, tableId, 'editing']

  isSavingTableColumns: (configurationId, tableId) ->
    _store.hasIn ['tableColumns', configurationId, tableId, 'isSaving']

dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when constants.ActionTypes.GOOD_DATA_WRITER_TABLES_FILTER_CHANGE
      _store = _store.setIn ['filters', action.configurationId, 'tables'], action.filter
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_START
      _store = _store.setIn ['writers', action.configurationId, 'isLoading'], true
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_ERROR
      _store = _store.setIn ['writers', action.configurationId, 'isLoading'], false
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_SUCCESS
      tablesById = Immutable
      .fromJS(action.configuration.tables)
      .toOrderedMap()
      .map (table) ->
        Map
          isLoading: false
          id: table.get('id') or table.get('tableId')
          editingFields: Map()
          savingFields: List()
          pendingActions: List()
          data: extendTable(table)
      .mapKeys (key, table) ->
        table.get('id')

      # open bucket it there is only one
      bucketToggles = Map()
      #buckets = tablesById.groupBy (table) -> table.getIn ['data', 'bucket']
      #if buckets.count() == 1
      #  bucketToggles = bucketToggles.set(buckets.keySeq().first(), true)

      _store = _store.withMutations (store) ->
        store
        .setIn ['writers', action.configuration.id, 'isLoading'], false
        .setIn ['writers', action.configuration.id, 'isDeleting'], false
        .setIn ['writers', action.configuration.id, 'isOptimizingSLI'], false
        .setIn ['writers', action.configuration.id, 'bucketToggles'], bucketToggles
        .setIn ['writers', action.configuration.id, 'config'], Immutable.fromJS action.configuration.writer
        .setIn ['tables', action.configuration.id], tablesById

      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_SAVE_TABLE_FIELD_START
      _store = _store.updateIn [
        'tables'
        action.configurationId
        action.tableId
        'savingFields'
      ], (fields) -> fields.push(action.field)
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_SAVE_TABLE_FIELD_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .setIn ['tables', action.configurationId, action.tableId, 'data', action.field], action.value
        .deleteIn ['tables', action.configurationId, action.tableId, 'editingFields', action.field]
        .updateIn ['tables', action.configurationId, action.tableId, 'savingFields'], (fields) ->
          fields.delete(fields.indexOf(action.field))
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_SAVE_TABLE_FIELD_ERROR
      _store = _store.updateIn ['tables', action.configurationId, action.tableId, 'savingFields'], (fields) ->
        fields.delete(fields.indexOf(action.field))
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_TABLE_SUCCESS
      columns = Immutable.OrderedMap(action.table.columns)
        .map (value) ->
          Map(value)
          .filter((value, key) ->
            key in [
              'gdName'
              'type'
              'name'
              'dataType',
              'dataTypeSize',
              'reference',
              'schemaReference',
              'format',
              'dateDimension',
              'sortLabel',
              'sortOrder'
              'identifier',
              'identifierLabel',
              'identifierTime',
              'title'
            ]
          )
        .map (column) ->
          if !column.get('title')
            column = column.set('title', column.get('gdName'))
          column

      table = Immutable.fromJS(action.table)
        .set 'bucket', action.table.id.split('.',2).join('.') # bucket is not returned by api

      _store = _store.withMutations (store) ->
        store
        .setIn ['tables', action.configurationId, table.get('id'), 'data'], extendTable(table.remove('columns'))
        .setIn ['tableColumns', action.configurationId, table.get('id'), 'current'], columns
      GoodDataWriterStore.emitChange()


    when constants.ActionTypes.GOOD_DATA_WRITER_LOAD_REFERENCABLE_TABLES_SUCCESS
      _store = _store.setIn ['referenceableTables', action.configurationId], Immutable.fromJS(action.tables)
      GoodDataWriterStore.emitChange()


    when constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_START
      _store = _store.withMutations (store) ->
        columns =  store.getIn ['tableColumns', action.configurationId, action.tableId, 'current']
        store
        .setIn ['tableColumns', action.configurationId, action.tableId, 'editing'],
          columns
        .setIn ['tableColumns', action.configurationId, action.tableId, 'references'],
          referencesForColumns(columns)

      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_COLUMNS_EDIT_CANCEL
      _store = _store.withMutations (store) ->
        store
        .deleteIn ['tableColumns', action.configurationId, action.tableId, 'editing']
        .deleteIn ['tableColumns', action.configurationId, action.tableId, 'invalidColumns']

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

        tableColumns
        .set 'editing', columns
        .set 'invalidColumns', getInvalidColumns(columns)
        .set 'references', referencesForColumns(columns)


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
        ], Immutable.OrderedMap(action.columns).map (value) -> Map value)

      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_TABLE_FIELD_EDIT_START
      _store = _store.setIn [
        'tables'
        action.configurationId
        action.tableId
        'editingFields'
        action.field
      ], GoodDataWriterStore.getTable(action.configurationId, action.tableId).getIn(['data', action.field])
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_TABLE_FIELD_EDIT_UPDATE
      _store = _store.setIn [
        'tables'
        action.configurationId
        action.tableId
        'editingFields'
        action.field
      ], action.value
      GoodDataWriterStore.emitChange()


    when constants.ActionTypes.GOOD_DATA_WRITER_TABLE_FIELD_EDIT_CANCEL
      _store = _store.deleteIn [
        'tables'
        action.configurationId
        action.tableId
        'editingFields'
        action.field
      ]
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_RESET_TABLE_START
      _store = _store.updateIn [
        'tables'
        action.configurationId
        action.tableId
        'pendingActions'
      ], (actions) ->
        actions.push 'resetTable'
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_RESET_TABLE_SUCCESS
      _store = _store.updateIn [
        'tables'
        action.configurationId
        action.tableId
        'pendingActions'
      ], (actions) ->
        actions.delete(actions.indexOf('resetTable'))
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_SYNC_TABLE_START
      _store = _store.updateIn [
        'tables'
        action.configurationId
        action.tableId
        'pendingActions'
      ], (actions) ->
        actions.push 'syncTable'
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_SYNC_TABLE_SUCCESS
      _store = _store.updateIn [
        'tables'
        action.configurationId
        action.tableId
        'pendingActions'
      ], (actions) ->
        actions.delete(actions.indexOf('syncTable'))
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_UPLOAD_START

      if action.tableId
        _store = _store.updateIn [
          'tables'
          action.configurationId
          action.tableId
          'pendingActions'
        ], (actions) ->
          actions.push 'uploadTable'
      else
        _store = _store.updateIn [
          'writers'
          action.configurationId
          'pendingActions'
        ], List(), (actions) ->
          actions.push 'uploadProject'
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_UPLOAD_ERROR, constants.ActionTypes.GOOD_DATA_WRITER_UPLOAD_SUCCESS

      if action.tableId
        _store = _store.updateIn [
          'tables'
          action.configurationId
          action.tableId
          'pendingActions'
        ], (actions) ->
          actions.delete(actions.indexOf('uploadTable'))
      else
        _store = _store.updateIn [
          'writers'
          action.configurationId
          'pendingActions'
        ], List(), (actions) ->
          actions.delete(actions.indexOf('uploadTable'))

      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_DELETE_START
      _store = _store.setIn [
        'writers'
        action.configurationId
        'isDeleting'
      ], true
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_DELETE_ERROR
      _store = _store.deleteIn [
        'writers'
        action.configurationId
        'isDeleting'
      ]
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_DELETE_SUCCESS
      _store = _store.deleteIn [
        'writers'
        action.configurationId
        'isDeleting'
      ]
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_SLI_START
      _store = _store.setIn [
        'writers'
        action.configurationId
        'isOptimizingSLI'
      ], true
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_SLI_SUCCESS, constants.ActionTypes.GOOD_DATA_WRITER_SLI_ERROR
      _store = _store.deleteIn [
        'writers'
        action.configurationId
        'isOptimizingSLI'
      ]
      GoodDataWriterStore.emitChange()


    when constants.ActionTypes.GOOD_DATA_WRITER_SET_BUCKET_TOGGLE
      current = _store.getIn [
        'writers'
        action.configurationId
        'bucketToggles'
        action.bucketId
      ], false

      _store = _store.setIn [
        'writers'
        action.configurationId
        'bucketToggles'
        action.bucketId
      ], !current

      GoodDataWriterStore.emitChange()


    when constants.ActionTypes.GOOD_DATA_WRITER_PROJECT_ACCESS_LOADING
      _store = _store.updateIn [
        'writers'
        action.configurationId
        'pendingActions'
      ], List(), (actions) ->
        actions.push 'projectAccess'
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_PROJECT_ACCESS_ENABLE
      _store = _store.updateIn [
        'writers'
        action.configurationId
        'pendingActions'
      ], List(), (actions) ->
        actions.delete(actions.indexOf('projectAccess'))
      _store = _store.setIn [
        'writers'
        action.configurationId
        'config'
        'project'
        'ssoAccess'
      ], true
      _store = _store.setIn [
        'writers'
        action.configurationId
        'config'
        'project'
        'ssoLink'
      ], action.ssoLink
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_PROJECT_ACCESS_DISABLE
      _store = _store.updateIn [
        'writers'
        action.configurationId
        'pendingActions'
      ], List(), (actions) ->
        actions.delete(actions.indexOf('projectAccess'))
      _store = _store.setIn [
        'writers'
        action.configurationId
        'config'
        'project'
        'ssoAccess'
      ], false
      GoodDataWriterStore.emitChange()

    when constants.ActionTypes.GOOD_DATA_WRITER_PROJECT_ACCESS_ERROR
      _store = _store.updateIn [
        'writers'
        action.configurationId
        'pendingActions'
      ], List(), (actions) ->
        actions.delete(actions.indexOf('projectAccess'))
      GoodDataWriterStore.emitChange()


module.exports = GoodDataWriterStore
