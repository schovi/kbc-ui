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
    path = "tables/#{tableId}/columns"
    createRequest('GET', driver, configId, path)
    .promise()
    .then (response) ->
      response.body
