
_ = require 'underscore'

###
  Periodic tasks executor
###
class Timer

  constructor: ->
    @_timers = []

  ###
    Will execute callback every `interval` seconds
  ###
  poll: (callback, interval = 30) ->
    timer = @
    @_timers.push
      callback: callback
      intervalId: setInterval(->
        timer._runAction callback
      , 1000 * interval)

  ###
    Stop periodic execution of callback
  ###
  stop: (callback) ->
    @_timers = _.filter @_timers, (timer) ->
      return true if timer.callback != callback
      clearInterval(timer.intervalId)
      false

  _runAction: (callback) ->
    callback()


module.exports = new Timer