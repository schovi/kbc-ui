SyrupApi = require '../components/SyrupComponentApi'
Immutable = require 'immutable'
dockerProxyApi = require('./templates/dockerProxyApi').default
#componentId = 'wr-db'

module.exports = (componentId) ->
  createRequest = (method, configId, path) ->
    #path = "#{driver}/#{configId}/#{path}"
    path = "#{configId}/#{path}"
    SyrupApi.createRequest(componentId, method, path)

  proxyApi = dockerProxyApi(componentId)

  getCredentials: (configId) ->
    proxyPromise = proxyApi?.getCredentials(configId)
    return proxyPromise or createRequest('GET', configId, 'credentials')
    .promise()
    .then (response) ->
      response.body

  postCredentials: (configId, credentials) ->
    credentials.allowedTypes = undefined
    createRequest('POST', configId, 'credentials')
    .send credentials
    .promise()
    .then (response) ->
      response.body

  deleteTable: (configId, tableId) ->
    createRequest('DELETE', configId, 'config-tables/' + tableId )
    .promise()

  getTables: (configId) ->
    proxyPromise = proxyApi?.getTables(configId)
    return proxyPromise or createRequest('GET', configId, 'config-tables')
    .promise()
    .then (response) ->
      response.body

  getTable: (configId, tableId) ->
    path = "config-tables/#{tableId}"
    createRequest('GET', configId, path)
    .promise()
    .then (response) ->
      response.body

  setTableColumns: (configId, tableId, columns) ->
    path = "tables/#{tableId}/columns"
    createRequest('POST', configId, path)
    .send columns
    .promise()
    .then (response) ->
      response.body

  setTable: (configId, tableId, dbName, isExported) ->
    exported = if isExported then 1 else 0
    path = "tables/#{tableId}"
    data =
      "dbName": dbName
      "export": exported
    createRequest('POST', configId, path)
    .send data
    .promise()
    .then (response) ->
      console.log "API RESPONSE", response
      response.body
