
Dispatcher = require('../Dispatcher.coffee')
Immutable = require('immutable')
{Map, List} = Immutable
Constants = require '../constants/KbcConstants.coffee'

_store = Map(
  sapiToken: Map()
  organizations: List()
  sapiUrl: ''
  kbc: Map() # contains - projectBaseUrl, admin (object)
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

  getCurrentProject: ->
    _store.getIn ['sapiToken', 'owner']

  getCurrentAdmin: ->
    _store.getIn ['kbc', 'admin']

  getProjectBaseUrl: ->
    console.log 'store', _store.get('kbc').toJS()
    _store.getIn ['kbc', 'projectBaseUrl']

  getProjectPageUrl: (path) ->
    @getProjectBaseUrl() + path

  getUrlTemplates: ->
    _store.getIn ['kbc', 'urlTemplates']

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.APPLICATION_DATA_RECEIVED
      console.log 'action', action
      _store = _store.withMutations (store) ->
        store
          .set 'sapiToken', Immutable.fromJS(action.applicationData.sapiToken)
          .set 'sapiUrl', action.applicationData.sapiUrl
          .set 'kbc', Immutable.fromJS(action.applicationData.kbc)
          .set 'organizations', Immutable.fromJS(action.applicationData.organizations)

module.exports = ApplicationStore