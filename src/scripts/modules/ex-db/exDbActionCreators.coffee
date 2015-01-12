

dispatcher = require '../../Dispatcher.coffee'
constants = require './exDbConstants.coffee'
Promise = require('bluebird')

exDbApi = require './exDbApi.coffee'
exDbStore = require './exDbStore.coffee'

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






