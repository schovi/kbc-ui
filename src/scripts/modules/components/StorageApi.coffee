request = require '../../utils/request'
parse = require '../../utils/parseCsv'
ApplicationStore = require '../../stores/ApplicationStore'

createUrl = (path) ->
  baseUrl = ApplicationStore.getSapiUrl()
  "#{baseUrl}/v2/storage/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())


storageApi =

  getBuckets: ->
    createRequest('GET', 'buckets')
    .promise()
    .then((response) ->
      response.body
    )

  getTables: ->
    createRequest('GET', 'tables?include=attributes,buckets,columns')
    .promise()
    .then((response) ->
      response.body
    )

  createToken: (params) ->
    createRequest 'POST', 'tokens'
    .type 'form'
    .send params
    .promise()
    .then (response) ->
      response.body


  getTokens: ->
    createRequest 'GET', 'tokens'
    .promise()
    .then (response) ->
      response.body

  getFiles: (params) ->
    createRequest('GET', 'files')
    .query params
    .promise()
    .then((response) ->
      response.body
    )

  getRunIdStats: (runId) ->
    createRequest 'GET', 'stats'
    .query runId: runId
    .promise()
    .then (response) ->
      response.body

  ###
    Returns parsed CSV info plain arrays
    [
      [] - row 1
      [] - row 2
    ]
  ###
  exportTable: (tableId, params) ->
    createRequest('GET', "tables/#{tableId}/export")
    .query params
    .promise()
    .then (response) ->
      parse response.text

module.exports = storageApi
