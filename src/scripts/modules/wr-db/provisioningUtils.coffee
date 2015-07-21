StorageService = require '../components/StorageActionCreators'
SapiStorage = require '../components/stores/StorageTokensStore'
Promise = require 'bluebird'
wrDbProvStore = require '../provisioning/stores/WrDbCredentialsStore'
provisioningActions = require '../provisioning/ActionCreators'


# load credentials and if they dont exists then create new
loadCredentials = (permission, token) ->
  provisioningActions.loadWrDbCredentials(permission, token).then ->
    creds = wrDbProvStore.getCredentials(permission, token)
    if creds
      return creds
    else
      return provisioningActions.createWrDbCredentials(permission, token).then ->
        return wrDbProvStore.getCredentials(permission, token)


getWrDbToken = ->
  StorageService.loadTokens().then ->
    tokens = SapiStorage.getAll()
    wrDbToken = tokens.find( (token) ->
      token.get('description') == 'wrdb'
      )
    return wrDbToken

retrieveProvisioningCredentials = (isReadOnly, wrDbToken) ->
  console.log "retrieve credentials", wrDbToken
  writePromise = null
  if not isReadOnly
    writePromise = loadCredentials('write', wrDbToken)
  readPromise = loadCredentials('read', wrDbToken).then (creds) ->
    console.log 'READ PROMISE RETURN', creds
    creds

  return Promise.props
    read: readPromise
    write: writePromise


module.exports =
  getCredentials: (isReadOnly) ->
    wrDbToken = null
    getWrDbToken().then (token) ->
      wrDbToken = token
      if not wrDbToken
        params =
          description: "wrdb"
          canManageBuckets: 1
        StorageService.createToken(params).then ->
          tokens = SapiStorage.getAll()
          wrDbToken = tokens.find( (token) ->
            token.get('description') == 'wrdb'
            )
          wrDbToken = wrDbToken.token
          retrieveProvisioningCredentials(isReadOnly, wrDbToken)
      else #token exists
        console.log "TOKEN EXISTS", wrDbToken.toJS()
        wrDbToken = wrDbToken.get 'token'
        retrieveProvisioningCredentials(isReadOnly, wrDbToken)
