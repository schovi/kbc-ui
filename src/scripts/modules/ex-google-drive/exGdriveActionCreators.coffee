dispatcher = require '../../Dispatcher.coffee'
constants = require './exDbConstants.coffee'
Promise = require('bluebird')
exGdriveApi = require './exGdriveApi.coffee'

module.exports =

    loadConfigurationForce: (configurationId) ->
    Promise.props
      id: configurationId
      queries: exDbApi.getQueries(configurationId)
      credentials: exDbApi.getCredentials(configurationId)
    .then (configuration) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.EX_DB_CONFIGURATION_LOAD_SUCCESS
        configuration: configuration


  loadConfiguration: (configurationId) ->
    return Promise.resolve() if exDbStore.hasConfig configurationId
    @loadConfigurationForce(configurationId)
