
Dispatcher = require('../dispatcher/KbcDispatcher.coffee')
Immutable = require('immutable')
Constants = require '../constants/KbcConstants.coffee'

_sapiToken = Immutable.Map({})

ApplicationStore =

  getSapiTokenString: ->
    _sapiToken.get 'token'


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.APPLICATION_DATA_RECEIVED
      _sapiToken = Immutable.Map(action.applicationData.sapiToken)


module.exports = ApplicationStore