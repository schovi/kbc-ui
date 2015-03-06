
Promise = require 'bluebird'
request = require './request'

_pollStatuses = [
  'processing'
  'waiting'
]

module.exports =
  poll: (token, url) ->

    new Promise (resolve, reject) ->

      runRequest = ->
        request('GET', url)
        .set('X-StorageApi-Token', token)
        .promise()
        .then (response) ->
          if _pollStatuses.indexOf(response.body.status) >= 0
            setTimeout runRequest, 5
          else
            resolve response.body
        .catch reject

      runRequest()
