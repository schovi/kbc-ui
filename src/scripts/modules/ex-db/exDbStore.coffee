
Dispatcher = require('../../Dispatcher.coffee')
constants = require './exDbConstants.coffee'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../../utils/StoreUtils.coffee'

_store = Map(
  configs: Map()
  editingQueries: Map() # [configId][queryId]
)

ExDbStore = StoreUtils.createStore

  getConfig: (configId) ->
    _store.getIn ['configs', configId]

  hasConfig: (configId) ->
    _store.hasIn ['configs', configId]

  getConfigQuery: (configId, queryId) ->
    _store.getIn ['configs', configId, 'queries', queryId]

  isEditingQuery: (configId, queryId) ->
    _store.hasIn ['editingQueries', configId, queryId]

  getEditingQuery: (configId, queryId) ->
    _store.getIn ['editingQueries', configId, queryId]

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

    when constants.ActionTypes.EX_DB_QUERY_DELETE
      _store = _store.deleteIn ['configs', action.configurationId, 'queries', action.queryId]
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

    when constants.ActionTypes.EX_DB_QUERY_EDIT_SAVE
      _store = _store.withMutations (store) ->
        store
        .setIn ['configs', action.configurationId, 'queries', action.queryId],
          ExDbStore.getEditingQuery(action.configurationId, action.queryId)
        .deleteIn ['editingQueries', action.configurationId, action.queryId]
      console.log 'store', _store.toJS()
      ExDbStore.emitChange()

module.exports = ExDbStore