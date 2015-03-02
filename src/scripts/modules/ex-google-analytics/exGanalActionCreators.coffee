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
