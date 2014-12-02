
Dispatcher = require('../dispatcher/KbcDispatcher.coffee')
Immutable = require('immutable')
Map = Immutable.Map
Constants = require '../constants/KbcConstants.coffee'

_store = Map()

ApplicationStore =

  getSapiTokenString: ->
    _store.getIn [ 'sapiToken', 'token' ]


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.APPLICATION_DATA_RECEIVED
      _store = _store.set 'sapiToken', Immutable.fromJS(action.applicationData.sapiToken)


module.exports = ApplicationStore