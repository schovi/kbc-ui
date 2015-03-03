Dispatcher = require('../../Dispatcher')
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require('../../utils/StoreUtils')
Constants = require './exGanalConstants'

_store = Map(
  configs: Map() #config by configId
  newQuery: Map() #configId
)


GanalStore = StoreUtils.createStore
  hasConfig: (configId)  ->
    _store.hasIn ['configs', configId]
  getConfig: (configId) ->
    _store.getIn(['configs', configId])

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

module.exports = GanalStore
