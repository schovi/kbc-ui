request = require('../../utils/request')
_ = require 'underscore'
Promise = require('bluebird')
SchemasStore = require './stores/SchemasStore'

createRequest = (method, url) ->
  request(method, url)

module.exports =
  getSchema: (componentId) ->
    url = 'https://g4cms8rol6.execute-api.us-east-1.amazonaws.com/prod/templates/' + componentId
    request('GET', url)
    .promise().then (response) ->
      return response.body
