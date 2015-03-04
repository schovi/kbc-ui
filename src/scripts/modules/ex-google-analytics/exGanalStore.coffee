Dispatcher = require('../../Dispatcher')
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require('../../utils/StoreUtils')
Constants = require './exGanalConstants'
_ = require 'underscore'
_store = Map(
  configs: Map() #config by configId
  newQuery: Map() #configId
  savingNewQuery: Map() #configId
)


GanalStore = StoreUtils.createStore
  hasConfig: (configId)  ->
    _store.hasIn ['configs', configId]
  getConfig: (configId) ->
    _store.getIn(['configs', configId])
  isSavingNewQuery: (configId) ->
    _store.hasIn ['savingNewQuery', configId]
  getConfigToSave: (configId) ->
    _store.getIn ['savingNewQuery', configId]
  getNewQuery: (configId) ->
    if _store.hasIn ['newQuery', configId]
      return _store.getIn ['newQuery', configId]
    newQuery = Immutable.fromJS
      name: ""
      metrics: []
      dimensions: []
      filters: ""
      profile: ""

    _store.setIn ['newQuery', configId], newQuery
    return newQuery




Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.EX_GANAL_CONFIGURATION_LOAD_SUCCEES
      configId = action.configId
      data = Immutable.fromJS(action.data)
      _store = _store.setIn(['configs', configId], data)
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_CHANGE_NEW_QUERY
      configId = action.configId
      _store = _store.setIn ['newQuery', configId], action.newQuery
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_NEW_QUERY_RESET
      configId = action.configId
      _store = _store.deleteIn ['newQuery', configId]
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_NEW_QUERY_CREATE_START
      configId = action.configId
      newQuery = _store.getIn ['newQuery', configId]
      newQueryName = newQuery.get 'name'
      filters = newQuery.get('filters')
      #ga ex api is retarded so is following statement
      if filters and not _.isArray filters
        newQuery = newQuery.set 'filters', [filters]
      config = GanalStore.getConfig(configId).get 'configuration'
      config = config.set(newQueryName, newQuery)
      _store = _store.setIn ['savingNewQuery', configId], config
      GanalStore.emitChange()

    when Constants.ActionTypes.EX_GANAL_NEW_QUERY_CREATE_SUCCESS
      configId = action.configId
      newConfig = action.newConfig
      _store = _store.setIn ['configs', configId], Immutable.fromJS(newConfig)

      _store = _store.deleteIn ['savingNewQuery', configId]
      _store = _store.deleteIn ['newQuery', configId]
      GanalStore.emitChange()


module.exports = GanalStore
