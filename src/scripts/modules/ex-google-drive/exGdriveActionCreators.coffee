dispatcher = require '../../Dispatcher.coffee'
constants = require './exGdriveConstants.coffee'
Promise = require('bluebird')
exGdriveApi = require './exGdriveApi.coffee'
exGdriveStore = require './exGdriveStore.coffee'
module.exports =

  loadConfigurationForce: (configurationId) ->
    Promise.props
      id: configurationId
      configuration: exGdriveApi.getConfiguration(configurationId)
    .then (configuration) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.EX_GDRIVE_CONFIGURATION_LOAD_SUCCESS
        configuration: configuration


  loadConfiguration: (configurationId) ->
    return Promise.resolve() if exGdriveStore.hasConfig configurationId
    @loadConfigurationForce(configurationId)
