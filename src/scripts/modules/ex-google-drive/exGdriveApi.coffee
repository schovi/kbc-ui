request = require('../../utils/request.coffee')
ApplicationStore = require '../../stores/ApplicationStore.coffee'
ComponentsStore = require '../components/stores/ComponentsStore.coffee'
Promise = require('bluebird')
#gdriveFilesMocked = require './api-mocks/gdFiles.coffee'
#gdConfigMocked  = require './api-mocks/gdConfig.coffee'
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
  getExtLink: (configId) ->
    data =
      'account': configId
      'referrer': 'https://s3.amazonaws.com/kbc-apps.keboola.com/ex-authorize/index.html#/googledrive'
    createRequest('POST', 'external-link')
      .send data
      .promise().then (response) ->
        response.body

  getConfiguration: (configId) ->
    #Promise.props(gdConfigMocked)
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

  getGdriveFileSheets: (configId, fileId) ->
    promisify createRequest('GET', "sheets/#{configId}/#{fileId}")

  getGdriveFiles: (configId, nextPageToken) ->
    nextPage = ''
    nextPage = "/#{nextPageToken}" if nextPageToken
    #Promise.props(gdriveFilesMocked)
    promisify createRequest('GET', "files/#{configId}#{nextPage}")
