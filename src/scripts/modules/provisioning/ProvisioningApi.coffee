
request = require '../../utils/request'
 
ApplicationStore = require '../../stores/ApplicationStore'
ComponentsStore = require '../components/stores/ComponentsStore'

createUrl = (path) ->
  baseUrl = ComponentsStore.getComponent('provisioning').get('uri')
  "#{baseUrl}/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())

provisioningApi =
  
  getCredentials: (backend, credentialsType) ->
    createRequest('GET', backend)
    .query({'type': credentialsType})
    .promise()
    .then((response) ->
      response.body
    )

  createCredentials: (backend, credentialsType) ->
    createRequest('POST', backend)
    .send({'type': credentialsType})
    .promise()
    .then((response) ->
      response.body
    )

  dropCredentials: (backend, credentialsId) ->
    createRequest('DELETE', backend + "/" + credentialsId)
    .promise()
    .then((response) ->
      response.body
    )

module.exports = provisioningApi