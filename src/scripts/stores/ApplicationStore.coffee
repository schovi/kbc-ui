
Dispatcher = require('../dispatcher/KbcDispatcher.coffee')
Immutable = require('immutable')
Map = Immutable.Map
Constants = require '../constants/KbcConstants.coffee'

_store = Map(
  sapiToken: Map()
  sapiUrl: ''
)

ApplicationStore =

  getSapiTokenString: ->
    _store.getIn [ 'sapiToken', 'token' ]

  getSapiUrl: ->
    _store.get 'sapiUrl'


Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.APPLICATION_DATA_RECEIVED
      _store = _store.withMutations (store) ->
        store
          .set 'sapiToken', Immutable.fromJS(action.applicationData.sapiToken)
          .set 'sapiUrl', action.applicationData.sapiUrl

module.exports = ApplicationStore