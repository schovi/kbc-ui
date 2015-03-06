

dispatcher = require '../../Dispatcher'
constants = require './Constants'
provisioningApi = require './ProvisioningApi'
mySqlSandboxCredentialsStore = require './stores/MySqlSandboxCredentialsStore'
redshiftSandboxCredentialsStore = require './stores/RedshiftSandboxCredentialsStore'
Promise = require 'bluebird'
HttpError = require '../../utils/HttpError'

module.exports =


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

  ###
  Request specified orchestration load from server
  @return Promise
  ###
  loadRedshiftSandboxCredentialsForce: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_LOAD
    )

    provisioningApi
    .getCredentials('redshift', 'sandbox')
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_LOAD_SUCCESS
        credentials: response.credentials
      )
      return
    ).catch(HttpError, (error) ->
      if error.response.status == 404
        dispatcher.handleViewAction(
          type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_LOAD_SUCCESS
          credentials:
            id: null
        )
      else
        dispatcher.handleViewAction(
          type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_LOAD_ERROR
        )
        throw error
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_LOAD_ERROR
      )
      throw error
    )

  loadRedshiftSandboxCredentials: ->
    return Promise.resolve() if redshiftSandboxCredentialsStore.getIsLoaded()
    @loadRedshiftSandboxCredentialsForce()


  createRedshiftSandboxCredentials: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_CREATE
    )

    provisioningApi
    .createCredentials('redshift', 'sandbox')
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_CREATE_SUCCESS
        credentials: response.credentials
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_CREATE_ERROR
      )
      throw error
    )

  dropRedshiftSandboxCredentials: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_DROP
    )

    provisioningApi
    .dropCredentials('redshift', redshiftSandboxCredentialsStore.getCredentials().get("id"))
    .then( ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_DROP_SUCCESS
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_DROP_ERROR
      )
      throw error
    )

  refreshRedshiftSandboxCredentials: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_REFRESH
    )

    provisioningApi
    .createCredentials('redshift', 'sandbox')
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_REFRESH_SUCCESS
        credentials: response.credentials
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_REDSHIFT_SANDBOX_REFRESH_ERROR
      )
      throw error
    )
