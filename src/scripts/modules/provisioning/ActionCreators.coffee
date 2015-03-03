

dispatcher = require '../../Dispatcher'
constants = require './Constants'
provisioningApi = require './ProvisioningApi'
credentialsStore = require './stores/CredentialsStore'
Promise = require 'bluebird'
HttpError = require '../../utils/HttpError'

module.exports =

  ###
    Request specified orchestration load from server
    @return Promise
  ###
  loadCredentialsForce: (backend, credentialsType) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_LOAD
      backend: backend
      credentialsType: credentialsType
    )

    provisioningApi
    .getCredentials(backend, credentialsType)
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_LOAD_SUCCESS
        credentials:
          credentials: response.credentials
          backend: backend
          credentialsType: credentialsType
      )
      return
    ).catch(HttpError, (error) ->
      if error.response.status == 404
        dispatcher.handleViewAction(
          type: constants.ActionTypes.CREDENTIALS_LOAD_SUCCESS
          credentials:
            credentials:
              id: null
            backend: backend
            credentialsType: credentialsType
          )
      else
        dispatcher.handleViewAction(
          type: constants.ActionTypes.CREDENTIALS_LOAD_ERROR
          backend: backend
          credentialsType: credentialsType
        )
        throw error
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_LOAD_ERROR
        backend: backend
        credentialsType: credentialsType
      )
      throw error
    )

  loadCredentials: (backend, credentialsType) ->
    return Promise.resolve() if credentialsStore.hasByBackendAndType(backend, credentialsType)
    @loadCredentialsForce(backend, credentialsType)
    
    
  createCredentials: (backend, credentialsType) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_CREATE
      backend: backend
      credentialsType: credentialsType
    )

    provisioningApi
    .createCredentials(backend, credentialsType)
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_CREATE_SUCCESS
        credentials:
          credentials: response.credentials
          backend: backend
          credentialsType: credentialsType
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_CREATE_ERROR
        backend: backend
        credentialsType: credentialsType
      )
      throw error
    )

  dropCredentials: (backend, credentialsId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_DROP
      backend: backend
      credentialsId: credentialsId
    )

    provisioningApi
    .dropCredentials(backend, credentialsId)
    .then( ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_DROP_SUCCESS
        backend: backend
        credentialsId: credentialsId
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_DROP_ERROR
        backend: backend
        credentialsId: credentialsId
      )
      throw error
    )