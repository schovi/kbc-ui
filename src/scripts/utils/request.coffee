request = require 'superagent'
Promise = require 'bluebird'
Request = require('superagent').Request


# Promise support for super agent http://visionmedia.github.io/superagent/#request-basics
Request.prototype.promise = ->
  req = @
  new Promise (resolve, reject) ->
    req.end (err, res) ->
      if err
        return reject err
      else if !res.ok
        return reject(
          status: res.status
          response: res
        )
      else
        resolve res


module.exports = request