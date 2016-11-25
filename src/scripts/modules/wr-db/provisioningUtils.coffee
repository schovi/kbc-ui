StorageService = require '../components/StorageActionCreators'
SapiStorage = require '../components/stores/StorageTokensStore'
Promise = require 'bluebird'
wrDbProvStore = require '../provisioning/stores/WrDbCredentialsStore'
provisioningActions = require '../provisioning/ActionCreators'

OLD_WR_REDSHIFT_COMPONENT_ID = 'wr-db-redshift'
NEW_WR_REDSHIFT_COMPONENT_ID = 'keboola.wr-redshift-v2'
WR_SNOWFLAKE_COMPONENT_ID = 'keboola.wr-db-snowflake'

# load credentials and if they dont exists then create new
loadCredentials = (permission, token, driver, forceRecreate, componentId) ->
  if driver == 'mysql'
    driver = 'wrdb'
  if componentId == OLD_WR_REDSHIFT_COMPONENT_ID
    driver = 'redshift'
  if componentId == NEW_WR_REDSHIFT_COMPONENT_ID
    driver = 'redshift-workspace'
    permission = 'writer'
  if componentId == WR_SNOWFLAKE_COMPONENT_ID
    driver = 'snowflake'
    permission = 'writer'

  provisioningActions.loadWrDbCredentials(permission, token, driver).then ->
    creds = wrDbProvStore.getCredentials(permission, token)
    if creds and not forceRecreate
      return creds
    else
      return provisioningActions.createWrDbCredentials(permission, token, driver).then ->
        return wrDbProvStore.getCredentials(permission, token)


getWrDbToken = (desc, legacyDesc) ->
  StorageService.loadTokens().then ->
    tokens = SapiStorage.getAll()
    wrDbToken = tokens.find( (token) ->
      token.get('description') in [desc, legacyDesc]
      )
    return wrDbToken

retrieveProvisioningCredentials = (isReadOnly, wrDbToken, driver, componentId) ->
  readPromise = null
  #enforce recreate read credentials for redshift only(permisson for)
  if driver == 'redshift'
    readPromise = loadCredentials('write', wrDbToken, driver, false, componentId)
  else
    readPromise = loadCredentials('read', wrDbToken, driver, false, componentId)
  writePromise = null
  if not isReadOnly
    if driver == 'redshift'
      return readPromise.then( (readResult) ->
        writePromise = loadCredentials('write', wrDbToken, driver, false, componentId)
        return Promise.props
          read: readResult
          write: writePromise
      )
    else
      writePromise = loadCredentials('write', wrDbToken, driver, false, componentId)
      return Promise.props
        read: readPromise
        write: writePromise
  else
    return Promise.props
      read: readPromise
      write: writePromise


module.exports =
  getCredentials: (isReadOnly, driver, componentId, configId) ->
    desc = "wrdb#{driver}_#{configId}"
    legacyDesc = "wrdb#{driver}"
    wrDbToken = null
    getWrDbToken(desc, legacyDesc).then (token) ->
      wrDbToken = token
      if not wrDbToken
        params =
          description: desc
          canManageBuckets: 1
        StorageService.createToken(params).then ->
          tokens = SapiStorage.getAll()
          wrDbToken = tokens.find( (token) ->
            token.get('description') == desc
            )
          wrDbToken = wrDbToken.get 'token'
          retrieveProvisioningCredentials(isReadOnly, wrDbToken, driver, componentId)
      else #token exists
        wrDbToken = wrDbToken.get 'token'
        retrieveProvisioningCredentials(isReadOnly, wrDbToken, driver, componentId)
