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
    request = createRequest('GET', 'account/' + configId)
    request.promise().then (response) ->
      response.body
