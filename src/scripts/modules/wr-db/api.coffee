SyrupApi = require '../components/SyrupComponentApi'
Immutable = require 'immutable'
componentId = 'wr-db'

createRequest = (method, configId, path) ->
  #path = "#{driver}/#{configId}/#{path}"
  path = "#{configId}/#{path}"
  SyrupApi.createRequest(componentId, method, path)

module.exports =
  getCredentials: (configId) ->
    createRequest('GET', configId, 'credentials')
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

  getTables: (configId) ->
    createRequest('GET', configId, 'tables')
    .promise()
    .then (response) ->
      response.body

  getTable: (configId, tableId) ->
    path = "tables/#{tableId}"
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
