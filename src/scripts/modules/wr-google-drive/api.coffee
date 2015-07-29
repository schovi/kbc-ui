SyrupApi = require '../components/SyrupComponentApi'
Immutable = require 'immutable'

createRequest = (method, path) ->
  SyrupApi.createRequest('wr-google-drive', method, path)

module.exports =

  getFiles: (configId) ->
    createRequest('GET', "files/#{configId}")
    .promise()
    .then (response) ->
      response.body
