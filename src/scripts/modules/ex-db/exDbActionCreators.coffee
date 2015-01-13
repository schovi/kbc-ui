

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

  updateEditingQuery: (configurationId, query) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_DB_QUERY_EDIT_UPDATE
      configurationId: configurationId
      query: query

  editQuery: (configurationId, queryId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_DB_QUERY_EDIT_START
      configurationId: configurationId
      queryId: queryId

  cancelQueryEdit: (configurationId, queryId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_DB_QUERY_EDIT_CANCEL
      configurationId: configurationId
      queryId: queryId

  saveQueryEdit: (configurationId, queryId) ->
    query = exDbStore.getEditingQuery configurationId, queryId

    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_DB_QUERY_EDIT_SAVE
      configurationId: configurationId
      queryId: queryId

    exDbApi
    .saveQuery configurationId, query.toJS()
    .then (response) ->
      console.log 'saved', response





