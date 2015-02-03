request = require('../../utils/request.coffee')
ApplicationStore = require '../../stores/ApplicationStore.coffee'
ComponentsStore = require '../components/stores/ComponentsStore.coffee'

createUrl = (path) ->
  baseUrl = ComponentsStore.getComponent('ex-google-drive').get('uri')
  "#{baseUrl}/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())

promisify = (pendingRequest) ->
  pendingRequest.promise().then (response) ->
    response.body

module.exports =
  getConfiguration: (configId) ->
    promisify createRequest('GET', 'account/' + configId )

  storeNewSheets: (configId, newSheetsArray) ->
    data =
      data: newSheetsArray
    createRequest('POST', 'sheets/' + configId)
      .send data
      .promise().then (response) ->
        response.body

  deleteSheet: (configId, fileId, sheetId) ->
    createRequest('DELETE', "sheet/#{configId}/#{fileId}/#{sheetId}")
      .promise()
      .then (response) ->
        response.body
