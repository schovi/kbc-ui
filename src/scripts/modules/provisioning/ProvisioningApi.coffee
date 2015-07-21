request = require '../../utils/request'

ApplicationStore = require '../../stores/ApplicationStore'
ComponentsStore = require '../components/stores/ComponentsStore'

createUrl = (path) ->
  baseUrl = ComponentsStore.getComponent('provisioning').get('uri')
  "#{baseUrl}/#{path}"

createRequest = (method, path, token) ->
  if not token
    token = ApplicationStore.getSapiTokenString()
  request(method, createUrl(path))
  .set('X-StorageApi-Token', token)

provisioningApi =

  getCredentials: (backend, credentialsType, token) ->
    createRequest('GET', backend, token)
    .query({'type': credentialsType})
    .promise()
    .then((response) ->
      response.body
    )

  createCredentials: (backend, credentialsType, token) ->
    createRequest('POST', backend, token)
    .send({'type': credentialsType})
    .promise()
    .then((response) ->
      response.body
    )

  dropCredentials: (backend, credentialsId, token) ->
    createRequest('DELETE', backend + "/" + credentialsId, token)
    .promise()
    .then((response) ->
      response.body
    )

module.exports = provisioningApi
