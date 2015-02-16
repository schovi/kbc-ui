
Dispatcher = require('../../Dispatcher')
constants = require './exDbConstants'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../../utils/StoreUtils'

_store = Map
  configs: Map()
  editingCredentials: Map() # [configId] - credentials
  savingCredentials: Map() # map of saving credentials ids
  editingQueries: Map() # [configId][queryId] - query
  deletingQueries: Map() # map of deleting query ids [configId][queryId] = true or not set
  savingQueries: Map() # map of saving query ids
  newQueries: Map() # [configId]['query'] - query [configId]['isSaving'] = true or not set

ExDbStore = StoreUtils.createStore

  getConfig: (configId) ->
    _store.getIn ['configs', configId]

  getDeletingQueries: (configId) ->
    _store.getIn ['deletingQueries', configId], Map()

  hasConfig: (configId) ->
    _store.hasIn ['configs', configId]

  getConfigQuery: (configId, queryId) ->
    _store.getIn ['configs', configId, 'queries', queryId]

  isEditingQuery: (configId, queryId) ->
    _store.hasIn ['editingQueries', configId, queryId]

  isSavingQuery: (configId, queryId) ->
    _store.hasIn ['savingQueries', configId, queryId]

  isSavingNewQuery: (configId) ->
    _store.getIn ['newQueries', configId, 'isSaving']

  getEditingQuery: (configId, queryId) ->
    _store.getIn ['editingQueries', configId, queryId]

  getNewQuery: (configId) ->
    _store.getIn ['newQueries', configId, 'query'], Map(
      incremental: false
      outputTable: ''
      primaryKey: ''
      query: ''
    )

  isEditingCredentials: (configId) ->
    _store.hasIn ['editingCredentials', configId]

  isSavingCredentials: (configId) ->
    _store.hasIn ['savingCredentials', configId]

  getEditingCredentials: (configId) ->
    _store.getIn ['editingCredentials', configId]

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when constants.ActionTypes.EX_DB_CONFIGURATION_LOAD_SUCCESS
      configuration = Immutable.fromJS(action.configuration).withMutations (configuration) ->
        configuration.set 'queries', configuration.get('queries').toMap().mapKeys((key, query) ->
          query.get 'id'
        )
      _store = _store.setIn ['configs', action.configuration.id], configuration
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_QUERY_DELETE_START
      _store = _store.setIn ['deletingQueries', action.configurationId, action.queryId], true
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_QUERY_DELETE_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .deleteIn ['configs', action.configurationId, 'queries', action.queryId]
        .deleteIn ['deletingQueries', action.configurationId, action.queryId]
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_QUERY_EDIT_START
      _store = _store.withMutations (store) ->
        store.setIn ['editingQueries', action.configurationId, action.queryId],
          ExDbStore.getConfigQuery action.configurationId, action.queryId
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_QUERY_EDIT_CANCEL
      _store = _store.deleteIn ['editingQueries', action.configurationId, action.queryId]
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_QUERY_EDIT_UPDATE
      # query is already in ImmutableJS structure
      _store = _store.setIn ['editingQueries', action.configurationId, action.query.get('id')], action.query
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_NEW_QUERY_UPDATE
      # query is already in ImmutableJS structure
      _store = _store.setIn ['newQueries', action.configurationId, 'query'], action.query
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_NEW_QUERY_RESET
      _store = _store.deleteIn ['newQueries', action.configurationId, 'query']
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_NEW_QUERY_SAVE_START
      _store = _store.setIn ['newQueries', action.configurationId, 'isSaving'], true
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_NEW_QUERY_SAVE_ERROR
      _store = _store.deleteIn ['newQueries', action.configurationId, 'isSaving']
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_NEW_QUERY_SAVE_SUCCESS
      _store = _store.withMutations (store) ->
        store
          .setIn ['configs', action.configurationId, 'queries', action.query.id], Immutable.fromJS(action.query)
          .deleteIn ['newQueries', action.configurationId]
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_QUERY_EDIT_SAVE_START
      _store = _store.withMutations (store) ->
        store
        .setIn ['savingQueries', action.configurationId, action.queryId], true
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_QUERY_EDIT_SAVE_ERROR
      _store = _store.deleteIn ['savingQueries', action.configurationId, action.queryId]
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_QUERY_EDIT_SAVE_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .setIn ['configs', action.configurationId, 'queries', action.queryId],
          Immutable.fromJS action.query
        .deleteIn ['editingQueries', action.configurationId, action.queryId]
        .deleteIn ['savingQueries', action.configurationId, action.queryId]
      ExDbStore.emitChange()

    ## Credentials edit handling
    when constants.ActionTypes.EX_DB_CREDENTIALS_EDIT_START
      _store = _store.withMutations (store) ->
        store.setIn ['editingCredentials', action.configurationId],
          ExDbStore.getConfig(action.configurationId).get 'credentials'
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_CREDENTIALS_EDIT_CANCEL
      _store = _store.deleteIn ['editingCredentials', action.configurationId]
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_CREDENTIALS_EDIT_UPDATE
      # credentials are already in ImmutableJS structure
      console.log 'edit', action.credentials.toJS()
      _store = _store.setIn ['editingCredentials', action.configurationId], action.credentials
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_CREDENTIALS_EDIT_SAVE_START
      _store = _store.withMutations (store) ->
        store
        .setIn ['savingCredentials', action.configurationId], true
      ExDbStore.emitChange()

    when constants.ActionTypes.EX_DB_CREDENTIALS_EDIT_SAVE_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .setIn ['configs', action.configurationId, 'credentials'],
            Immutable.fromJS action.credentials
        .deleteIn ['editingCredentials', action.configurationId]
        .deleteIn ['savingCredentials', action.configurationId]
      ExDbStore.emitChange()


module.exports = ExDbStore