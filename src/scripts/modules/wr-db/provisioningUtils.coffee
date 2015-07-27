StorageService = require '../components/StorageActionCreators'
SapiStorage = require '../components/stores/StorageTokensStore'
Promise = require 'bluebird'
wrDbProvStore = require '../provisioning/stores/WrDbCredentialsStore'
provisioningActions = require '../provisioning/ActionCreators'


# load credentials and if they dont exists then create new
loadCredentials = (permission, token, driver) ->
  if driver == 'mysql'
    driver = 'wrdb'
  provisioningActions.loadWrDbCredentials(permission, token, driver).then ->
    creds = wrDbProvStore.getCredentials(permission, token)
    if creds
      return creds
    else
      return provisioningActions.createWrDbCredentials(permission, token, driver).then ->
        return wrDbProvStore.getCredentials(permission, token)


getWrDbToken = (driver) ->
  StorageService.loadTokens().then ->
    tokens = SapiStorage.getAll()
    wrDbToken = tokens.find( (token) ->
      token.get('description') == "wrdb#{driver}"
      )
    return wrDbToken

retrieveProvisioningCredentials = (isReadOnly, wrDbToken, driver) ->
  console.log "retrieve credentials", wrDbToken
  writePromise = null
  if not isReadOnly
    writePromise = loadCredentials('write', wrDbToken, driver)
  readPromise = loadCredentials('read', wrDbToken, driver).then (creds) ->
    console.log 'READ PROMISE RETURN', creds
    creds

  return Promise.props
    read: readPromise
    write: writePromise


module.exports =
  getCredentials: (isReadOnly, driver) ->
    desc = "wrdb#{driver}"
    wrDbToken = null
    getWrDbToken(driver).then (token) ->
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
          retrieveProvisioningCredentials(isReadOnly, wrDbToken, driver)
      else #token exists
        console.log "TOKEN EXISTS", wrDbToken.toJS()
        wrDbToken = wrDbToken.get 'token'
        retrieveProvisioningCredentials(isReadOnly, wrDbToken, driver)
