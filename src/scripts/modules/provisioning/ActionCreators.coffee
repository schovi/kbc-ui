

dispatcher = require '../../Dispatcher'
constants = require './Constants'
provisioningApi = require './ProvisioningApi'
credentialsStore = require './stores/CredentialsStore'
mySqlSandboxCredentialsStore = require './stores/MySqlSandboxCredentialsStore'
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




  ###
  Request specified orchestration load from server
  @return Promise
  ###
  loadMySqlSandboxCredentialsForce: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_MYSQL_SANDBOX_LOAD
    )

    provisioningApi
    .getCredentials('mysql', 'sandbox')
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_MYSQL_SANDBOX_LOAD_SUCCESS
        credentials: response.credentials
      )
      return
    ).catch(HttpError, (error) ->
      if error.response.status == 404
        dispatcher.handleViewAction(
          type: constants.ActionTypes.CREDENTIALS_MYSQL_SANDBOX_LOAD_SUCCESS
          credentials:
            id: null
        )
      else
        dispatcher.handleViewAction(
          type: constants.ActionTypes.CREDENTIALS_MYSQL_SANDBOX_LOAD_ERROR
        )
        throw error
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_MYSQL_SANDBOX_LOAD_ERROR
      )
      throw error
    )

  loadMySqlSandboxCredentials: ->
    return Promise.resolve() if mySqlSandboxCredentialsStore.getIsLoaded()
    @loadMySqlSandboxCredentialsForce()


  createMySqlSandboxCredentials: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_MYSQL_SANDBOX_CREATE
    )

    provisioningApi
    .createCredentials('mysql', 'sandbox')
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_MYSQL_SANDBOX_CREATE_SUCCESS
        credentials: response.credentials
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_MYSQL_SANDBOX_CREATE_ERROR
      )
      throw error
    )

  dropMySqlSandboxCredentials: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_MYSQL_SANDBOX_DROP
    )

    provisioningApi
    .dropCredentials('mysql', mySqlSandboxCredentialsStore.getCredentials().get("id"))
    .then( ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_MYSQL_SANDBOX_DROP_SUCCESS
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_MYSQL_SANDBOX_DROP_ERROR
      )
      throw error
    )
