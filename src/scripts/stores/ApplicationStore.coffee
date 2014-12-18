
Dispatcher = require('../Dispatcher.coffee')
Immutable = require('immutable')
{Map, List} = Immutable
Constants = require '../constants/KbcConstants.coffee'

_store = Map(
  sapiToken: Map()
  organizations: List()
  sapiUrl: ''
)

ApplicationStore =

  getSapiTokenString: ->
    _store.getIn [ 'sapiToken', 'token' ]

  getSapiUrl: ->
    _store.get 'sapiUrl'

  getOrganizations: ->
    _store.get 'organizations'

  getCurrentProjectId: ->
    _store.getIn ['sapiToken', 'owner', 'id']

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.APPLICATION_DATA_RECEIVED
      _store = _store.withMutations (store) ->
        store
          .set 'sapiToken', Immutable.fromJS(action.applicationData.sapiToken)
          .set 'sapiUrl', action.applicationData.sapiUrl
          .set 'organizations', Immutable.fromJS(action.applicationData.organizations)

module.exports = ApplicationStore