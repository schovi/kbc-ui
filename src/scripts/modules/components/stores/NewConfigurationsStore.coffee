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
    domain: ''
    customDomain: false
    name: ''
    description: ''
    pid: ''
    username: ''
    password: ''
    authToken: constants.GoodDataWriterTokenTypes.DEMO
    mode: constants.GoodDataWriterModes.NEW
    readModel: true
    #accessToken: '' DEPRECATED
    # tokenType: constants.GoodDataWriterTokenTypes.DEMO DEPRECATED

getDefaultConfiguration = (componentId) ->
  _defaults.get componentId, Map(
    name: ''
    description: ''
  )

isCustomGoodDataToken = (token) ->
  token not in [constants.GoodDataWriterTokenTypes.DEMO, constants.GoodDataWriterTokenTypes.PRODUCTION]

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
          if constants.isCustomAuthToken(configuration.get('authToken'))
            return false if !configuration.get('authToken').trim()
        when constants.GoodDataWriterModes.EXISTING
          return false if !configuration.get('pid').trim()
          return false if !configuration.get('password').trim()
          return false if !configuration.get('username').trim()
      if configuration.get('customDomain')
        return false if !configuration.get('domain').trim()
        return false if !configuration.get('password').trim()
        return false if !configuration.get('username').trim()
    true

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
