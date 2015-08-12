request = require 'superagent'
Promise = require 'bluebird'
Request = require('superagent').Request
HttpError = require './HttpError'



# Promise support for super agent http://visionmedia.github.io/superagent/#request-basics
Request.prototype.promise = ->
  req = @
  promise = new Promise (resolve, reject) ->
    req.end (err, res) ->
      if err
        return reject err
      else if !res.ok
        return reject(new HttpError(res))
      else
        resolve res
  promise.cancellable()


module.exports = (method, url) ->
  request(method, url)
  .timeout 60000