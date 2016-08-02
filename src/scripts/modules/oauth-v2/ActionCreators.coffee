dispatcher = require('../../Dispatcher')
Promise = require('bluebird')
oauthStore = require './Store'
oauthApi = require './Api'
Constants = require('./Constants')
Immutable = require('immutable')

module.exports =

  loadCredentials: (componentId, id) ->
    if oauthStore.hasCredentials(componentId, id)
      return Promise.resolve()
    @loadCredentialsForce(componentId, id)


  loadCredentialsForce: (componentId, id) ->
    oauthApi.getCredentials(componentId, id).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.OAUTHV2_LOAD_CREDENTIALS_SUCCESS
        componentId: componentId
        id: id
        credentials: Immutable.fromJS(result)
      return result
    .catch (err) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.OAUTHV2_LOAD_CREDENTIALS_ERROR
        componentId: componentId
        id: id
      throw err


  deleteCredentials: (componentId, id) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.OAUTHV2_DELETE_CREDENTIALS_START
      componentId: componentId
      id: id
    oauthApi.deleteCredentials(componentId, id).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.OAUTHV2_DELETE_CREDENTIALS_SUCCESS
        componentId: componentId
        id: id
        credentials: result
    .catch (err) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.OAUTHV2_API_ERROR
        componentId: componentId
        id: id
      throw err
