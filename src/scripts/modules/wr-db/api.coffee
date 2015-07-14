SyrupApi = require '../components/SyrupComponentApi'
Immutable = require 'immutable'

createRequest = (method, driver, configId, path) ->
  #path = "#{driver}/#{configId}/#{path}"
  path = "#{configId}/#{path}"
  SyrupApi.createRequest('wr-db', method, path)

module.exports =
  getCredentials: (driver, configId) ->
    createRequest('GET', driver, configId, 'credentials')
    .promise()
    .then (response) ->
      response.body

  getTables: (driver, configId) ->
    createRequest('GET', driver, configId, 'tables')
    .promise()
    .then (response) ->
      response.body

  getColumns: (driver, configId, tableId) ->
    path = "tables/#{tableId}"
    createRequest('GET', driver, configId, path)
    .promise()
    .then (response) ->
      response.body

  setTable: (driver, configId, tableId, dbName, isExported) ->
    exported = if isExported then 1 else 0
    path = "tables/#{tableId}"
    data =
      "dbName": dbName
      "export": exported
    createRequest('POST', driver, configId, path)
    .send data
    .promise()
    .then (response) ->
      console.log "API RESPONSE", response
      response.body
