request = require('../../utils/request')
_ = require 'underscore'
Promise = require('bluebird')
ApplicationStore = require '../../stores/ApplicationStore'
ComponentsStore = require '../components/stores/ComponentsStore'

createUrl = (path) ->
  baseUrl = ComponentsStore.getComponent('keboola.oauth-v2').get('uri')
  "#{baseUrl}/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())

module.exports =
  getCredentials: (componentId, id) ->
    createRequest('GET', "credentials/#{componentId}/#{id}")
    .promise().then (response) ->
      return response.body

  deleteCredentials: (componentId, id) ->
    createRequest('DELETE', "credentials/#{componentId}/#{id}")
    .promise().then (response) ->
      return response.body
