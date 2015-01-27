Dispatcher = require('../../Dispatcher.coffee')
Constants = require './exGdriveConstants.coffee'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../../utils/StoreUtils.coffee'


_store = Map()



GdriveStore = StoreUtils.createStore
  hasConfig: (configId) ->
    _store.has configId
  getConfig: (configId) ->
    _store.get configId


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.EX_GDRIVE_CONFIGURATION_LOAD_SUCCESS
      configId = action.configuration.id
      configObject = action.configuration.configuration
      if not GdriveStore.hasConfig configId
        _store.set configId, Map()
      _store = _store.set(configId, Immutable.fromJS(configObject))


module.exports = GdriveStore
