request = require('../../utils/request')
_ = require 'underscore'
Promise = require('bluebird')
ApplicationStore = require '../../stores/ApplicationStore'

createUrl = (path) ->
  baseUrl = 'https://syrup.keboola.com/oauth'
  "#{baseUrl}/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())

module.exports =
  getCredentials: (componentId, configId) ->
    createRequest('GET', "credentials/#{componentId}/#{configId}")
    .promise().then (response) ->
      return response.body

  deleteCredentials: (componentId, configId) ->
    createRequest('DELETE', "credentials/#{componentId}/#{configId}")
    .promise().then (response) ->
      return response.body
