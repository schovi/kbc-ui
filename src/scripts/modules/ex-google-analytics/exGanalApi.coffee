request = require('../../utils/request')

ApplicationStore = require '../../stores/ApplicationStore'
ComponentsStore = require '../components/stores/ComponentsStore'
Promise = require('bluebird')
#gdriveFilesMocked = require './api-mocks/gdFiles'
#gdConfigMocked  = require './api-mocks/gdConfig'
createUrl = (path) ->
  baseUrl = ComponentsStore.getComponent('ex-google-analytics').get('uri')
  "#{baseUrl}/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())

module.exports =
  getConfig: (configId) ->
    createRequest('GET', 'account/' + configId)
    .promise().then (response) ->
      response.body

  postConfig: (configId, data) ->
    console.log 'data to POST', data
    configData =
      configuration: data
    createRequest('POST', "account/#{configId}")
    .send(configData)
    .promise().then (response) ->
      console.log 'POST OK', response.body
      return response.body
