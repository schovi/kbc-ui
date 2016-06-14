dispatcher = require '../../Dispatcher'
constants = require './Constants'
provisioningApi = require './ProvisioningApi'
mySqlSandboxCredentialsStore = require './stores/MySqlSandboxCredentialsStore'
redshiftSandboxCredentialsStore = require './stores/RedshiftSandboxCredentialsStore'
snowflakeSandboxCredentialsStore = require './stores/SnowflakeSandboxCredentialsStore'
WrDbCredentialsStore = require './stores/WrDbCredentialsStore'
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

  ###
   WR DB CREDENTIALS ACTIONS
  ###
  loadWrDbCredentialsForce: (permissionType, token, driver) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_WRDB_LOAD
      permission: permissionType
      token: token
    )

    provisioningApi
    .getCredentials(driver, permissionType, token)
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_WRDB_LOAD_SUCCESS
        credentials: response.credentials
        permission: permissionType
        token: token
      )
      return
    ).catch(HttpError, (error) ->
      if error.response.status == 404
        dispatcher.handleViewAction(
          type: constants.ActionTypes.CREDENTIALS_WRDB_LOAD_SUCCESS
          credentials: null
          permission: permissionType
          token: token
        )
      else
        dispatcher.handleViewAction(
          type: constants.ActionTypes.CREDENTIALS_WRDB_LOAD_ERROR
          permission: permissionType
          token: token
        )
        throw error
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_WRDB_LOAD_ERROR
        permission: permissionType
        token: token
      )
      throw error
    )

  loadWrDbCredentials: (permissionType, token, driver) ->
    isLoaded = WrDbCredentialsStore.getIsLoaded(permissionType, token)
    return Promise.resolve() if isLoaded
    @loadWrDbCredentialsForce(permissionType, token, driver)


  createWrDbCredentials: (permissionType, token, driver) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_WRDB_CREATE
      permission: permissionType
      token: token

    )

    provisioningApi
    .createCredentials(driver, permissionType, token)
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_WRDB_CREATE_SUCCESS
        credentials: response.credentials
        permission: permissionType
        token: token
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_WRDB_CREATE_ERROR
        permission: permissionType
        token: token

      )
      throw error
    )

  dropWrDbCredentials: (permissionType, token, driver) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_WRDB_DROP
      permission: permissionType
      token: token
    )
    credentials = WrDbCredentialsStore.getCredentials(permissionType, token)
    provisioningApi
    .dropCredentials(driver, credentials.get("id"), token)
    .then( ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_WRDB_DROP_SUCCESS
        permission: permissionType
        token: token
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_WRDB_DROP_ERROR
        permission: permissionType
        token: token
      )
      throw error
    )

  ###
  Request specified orchestration load from server
  @return Promise
  ###
  loadSnowflakeSandboxCredentialsForce: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_LOAD
    )

    provisioningApi
    .getCredentials('snowflake', 'sandbox')
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_LOAD_SUCCESS
        credentials: response.credentials
      )
      return
    ).catch(HttpError, (error) ->
      if error.response.status == 404
        dispatcher.handleViewAction(
          type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_LOAD_SUCCESS
          credentials:
            id: null
        )
      else
        dispatcher.handleViewAction(
          type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_LOAD_ERROR
        )
        throw error
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_LOAD_ERROR
      )
      throw error
    )

  loadSnowflakeSandboxCredentials: ->
    return Promise.resolve() if snowflakeSandboxCredentialsStore.getIsLoaded()
    @loadSnowflakeSandboxCredentialsForce()


  createSnowflakeSandboxCredentials: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_CREATE
    )

    provisioningApi
    .createCredentials('snowflake', 'sandbox')
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_CREATE_SUCCESS
        credentials: response.credentials
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_CREATE_ERROR
      )
      throw error
    )

  dropSnowflakeSandboxCredentials: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_DROP
    )

    provisioningApi
    .dropCredentials('snowflake', snowflakeSandboxCredentialsStore.getCredentials().get("id"))
    .then( ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_DROP_SUCCESS
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_DROP_ERROR
      )
      throw error
    )

  refreshSnowflakeSandboxCredentials: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_REFRESH
    )

    provisioningApi
    .createCredentials('snowflake', 'sandbox')
    .then((response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_REFRESH_SUCCESS
        credentials: response.credentials
      )
      return
    ).catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.CREDENTIALS_SNOWFLAKE_SANDBOX_REFRESH_ERROR
      )
      throw error
    )
