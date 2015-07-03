dispatcher = require('../../Dispatcher')
Promise = require('bluebird')
oauthStore = require './OAuthStore'
oauthApi = require './OAuthApi'
Constants = require('./OAuthConstants')
Immutable = require('immutable')

module.exports =

  loadCredentials: (componentId, configId) ->
    if oauthStore.hasCredentials(componentId, configId)
      return Promise.resolve()
    @loadCredentialsForce(componentId, configId)


  loadCredentialsForce: (componentId, configId) ->
    oauthApi.getCredentials(componentId, configId).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.OAUTH_LOAD_CREDENTIALS_SUCCESS
        componentId: componentId
        configId: configId
        credentials: Immutable.fromJS(result)
      return result
    .catch (err) ->
      console.log "LOAD CREDENTIALS API ERROR", err
      dispatcher.handleViewAction
        type: Constants.ActionTypes.OAUTH_LOAD_CREDENTIALS_ERROR
        componentId: componentId
        configId: configId


  deleteCredentials: (componentId, configId) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.OAUTH_DELETE_CREDENTIALS_START
      componentId: componentId
      configId: configId
    oauthApi.deleteCredentials(componentId, configId).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.OAUTH_DELETE_CREDENTIALS_SUCCESS
        componentId: componentId
        configId: configId
        credentials: result
    .catch (err) ->
      console.log "DELETE CREDENTIALS API ERROR", err
      dispatcher.handleViewAction
        type: Constants.ActionTypes.OAUTH_API_ERROR
        componentId: componentId
        configId: configId
