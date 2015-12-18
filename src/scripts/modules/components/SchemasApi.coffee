request = require('../../utils/request')
_ = require 'underscore'
Promise = require('bluebird')
SchemasStore = require './stores/SchemasStore'

createRequest = (method, url) ->
  request(method, url)

module.exports =
  getSchema: (componentId) ->
    url = 'https://2aom76uwth.execute-api.us-east-1.amazonaws.com/prod/schemas/' + componentId
    request('GET', url)
    .promise().then (response) ->
      return response.body
