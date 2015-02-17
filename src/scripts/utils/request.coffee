request = require 'superagent'
Promise = require 'bluebird'
Request = require('superagent').Request


class HttpError extends Error

  constructor: (@response) ->
    @message = @response.body?.error



# Promise support for super agent http://visionmedia.github.io/superagent/#request-basics
Request.prototype.promise = ->
  req = @
  new Promise (resolve, reject) ->
    req.end (err, res) ->
      console.log 'end', err, res
      if err
        return reject err
      else if !res.ok
        return reject(new HttpError(res))
      else
        resolve res


module.exports = request