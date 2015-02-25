Dispatcher = require('../../../Dispatcher')
constants = require '../Constants'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../../../utils/StoreUtils'

_store = Map(
  configurations: Map() # indexed by component id
)

NewConfigurationsStore = StoreUtils.createStore

  getConfiguration: (componentId) ->
    _store.getIn ['configurations', componentId],
      Map
        name: ''
        description: ''

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_UPDATE
      _store = _store.setIn ['configurations', action.componentId], action.configuration
      NewConfigurationsStore.emitChange()

    when constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_CANCEL
      _store = _store.deleteIn ['configurations', action.componentId]
      NewConfigurationsStore.emitChange()

module.exports = NewConfigurationsStore

