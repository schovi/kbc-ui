Dispatcher = require('../../../Dispatcher')
constants = require '../Constants'
Immutable = require('immutable')
Map = Immutable.Map
StoreUtils = require '../../../utils/StoreUtils'

_store = Map(
  configurations: Map() # indexed by component id
  saving: Map()
)

_defaults = Immutable.fromJS
  'gooddata-writer':
    name: ''
    description: ''
    pid: ''
    username: ''
    password: ''
    accessToken: ''
    mode: 'new'
    tokenType: 'production'

getDefaultConfiguration = (componentId) ->
  _defaults.get componentId, Map(
    name: ''
    description: ''
  )

NewConfigurationsStore = StoreUtils.createStore

  getConfiguration: (componentId) ->
    _store.getIn ['configurations', componentId],
      getDefaultConfiguration componentId

  isValidConfiguration: (componentId) ->
    !!@getConfiguration(componentId).get('name').trim()

  isSavingConfiguration: (componentId) ->
    _store.hasIn ['saving', componentId]

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_UPDATE
      _store = _store.setIn ['configurations', action.componentId], action.configuration
      NewConfigurationsStore.emitChange()

    when constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_CANCEL
      _store = _store.deleteIn ['configurations', action.componentId]
      NewConfigurationsStore.emitChange()

    when constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_START
      _store = _store.setIn ['saving', action.componentId], true
      NewConfigurationsStore.emitChange()

    when constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_ERROR
      _store = _store.deleteIn ['saving', action.componentId]
      NewConfigurationsStore.emitChange()

    when constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_SUCCESS
      _store = _store.withMutations (store) ->
        store
        .deleteIn ['saving', action.componentId]
        .deleteIn ['configurations', action.componentId]

      NewConfigurationsStore.emitChange()

module.exports = NewConfigurationsStore

