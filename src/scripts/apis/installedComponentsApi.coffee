
Promise = require 'bluebird'
request = require 'superagent'
require 'superagent-bluebird-promise'

ApplicationStore = require '../stores/ApplicationStore.coffee'

createUrl = (path) ->
  "https://connection.keboola.com/v2/storage/#{path}"

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())


installedComponentsApi =

  getComponents: ->
    createRequest('GET', 'components')
    .promise()
    .then((response) ->
      response.body
    )


module.exports = installedComponentsApi