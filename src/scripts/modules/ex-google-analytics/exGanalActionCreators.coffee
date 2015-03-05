dispatcher = require '../../Dispatcher'
Constants = require('./exGanalConstants')
Promise = require('bluebird')
exGanalApi = require './exGanalApi'
exGanalStore = require './exGanalStore'

module.exports =
  loadConfiguration: (configId) ->
    if exGanalStore.hasConfig(configId)
      return Promise.resolve()
    @loadConfigurationForce(configId)

  loadConfigurationForce: (configId) ->
    exGanalApi.getConfig(configId).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_CONFIGURATION_LOAD_SUCCEES
        configId: configId
        data: result

  toogleEditing: (configId, name, initQuery) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_QUERY_TOOGLE_EDITING
      configId: configId
      initQuery: initQuery
      name: name

  saveQuery: (configId, name) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_QUERY_SAVE_START
      configId: configId
      name: name
    config = exGanalStore.getConfigToSave(configId)
    exGanalApi.postConfig(configId, config.toJS()).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_QUERY_SAVE_SUCCESS
        configId: configId
        name: name
        newConfig: result

  resetQuery: (configId, name) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_QUERY_RESET
      configId: configId
      name: name

  changeQuery: (configId, name, newQuery) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_CHANGE_QUERY
      configId: configId
      newQuery: newQuery
      name: name

  changeNewQuery: (configId, newQuery) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_CHANGE_NEW_QUERY
      configId: configId
      newQuery: newQuery

  resetNewQuery: (configId) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_NEW_QUERY_RESET
      configId: configId

  createQuery: (configId) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_NEW_QUERY_CREATE_START
      configId: configId
    config = exGanalStore.getConfigToSave(configId)
    exGanalApi.postConfig(configId, config.toJS()).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_NEW_QUERY_CREATE_SUCCESS
        configId: configId
        newConfig: result
