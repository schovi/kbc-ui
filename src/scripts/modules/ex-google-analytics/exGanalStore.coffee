Dispatcher = require('../../Dispatcher')
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require('../../utils/StoreUtils')
Constants = require './exGanalConstants'

_store = Map(
  configs: Map() #config by configId
)


GanalStore = StoreUtils.createStore
  hasConfig: (configId)  ->
    _store.hasIn ['configs', configId]
  getConfig: (configId) ->
    _store.getIn(['configs', configId])


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.EX_GANAL_CONFIGURATION_LOAD_SUCCEES
      configId = action.configId
      data = Immutable.fromJS(action.data)
      _store = _store.setIn(['configs', configId], data)
      GanalStore.emitChange()


module.exports = GanalStore
