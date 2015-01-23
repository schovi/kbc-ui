

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
      type: constants.ActionTypes.EX_DB_QUERY_EDIT_SAVE_START
      configurationId: configurationId
      queryId: queryId

    exDbApi
    .saveQuery configurationId, query.toJS()
    .then (response) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.EX_DB_QUERY_EDIT_SAVE_SUCCESS
        configurationId: configurationId
        queryId: queryId
        query: response

  createQuery: (configurationId) ->
    newQuery = exDbStore.getNewQuery configurationId
    exDbApi
    .createQuery configurationId, newQuery.toJS()
    .then (newQuery) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.EX_DB_NEW_QUERY_CREATED
        configurationId: configurationId
        query: newQuery


  updateNewQuery: (configurationId, query) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_DB_NEW_QUERY_UPDATE
      configurationId: configurationId
      query: query

  resetNewQuery: (configurationId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_DB_NEW_QUERY_RESET
      configurationId: configurationId

  deleteQuery: (configurationId, queryId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_DB_QUERY_DELETE
      configurationId: configurationId
      queryId: queryId

    exDbApi
    .deleteQuery configurationId, queryId

  ###
    Credentials actions
  ###
  editCredentials: (configurationId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_DB_CREDENTIALS_EDIT_START
      configurationId: configurationId

  cancelCredentialsEdit: (configurationId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_DB_CREDENTIALS_EDIT_CANCEL
      configurationId: configurationId

  updateEditingCredentials: (configurationId, credentials) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_DB_CREDENTIALS_EDIT_UPDATE
      configurationId: configurationId
      credentials: credentials

  saveCredentialsEdit: (configurationId) ->
    credentials = exDbStore.getEditingCredentials configurationId

    dispatcher.handleViewAction
      type: constants.ActionTypes.EX_DB_CREDENTIALS_EDIT_SAVE_START
      configurationId: configurationId

    exDbApi
    .saveCredentials configurationId, credentials.toJS()
    .then (response) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.EX_DB_CREDENTIALS_EDIT_SAVE_SUCCESS
        configurationId: configurationId
        credentials: response

  testCredentials: (credentials) ->
    exDbApi.testAndWaitForCredentials credentials.toJS()





