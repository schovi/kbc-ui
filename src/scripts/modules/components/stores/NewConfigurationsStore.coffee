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
    mode: constants.GoodDataWriterModes.NEW
    tokenType: constants.GoodDataWriterTokenTypes.PRODUCTION

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
    configuration = @getConfiguration(componentId)
    return false if !configuration.get('name').trim()

    if componentId == 'gooddata-writer'
      switch configuration.get('mode')
        when constants.GoodDataWriterModes.NEW
          if configuration.get('tokenType') == constants.GoodDataWriterTokenTypes.CUSTOM
            return false if !configuration.get('accessToken').trim()
        when constants.GoodDataWriterModes.EXISTING
          return false if !configuration.get('pid').trim()
          return false if !configuration.get('password').trim()
          return false if !configuration.get('username').trim()
    true

  isSavingConfiguration: (componentId) ->
    _store.hasIn ['saving', componentId]

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type

    when constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_UPDATE
      console.log action, action.configuration.toJSON()
      console.log _store.toJSON()
      _store = _store.setIn ['configurations', action.componentId], action.configuration
      console.log _store.toJSON()
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

