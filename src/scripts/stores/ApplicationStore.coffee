Dispatcher = require('../Dispatcher')
Immutable = require('immutable')
{Map, List} = Immutable
Constants = require '../constants/KbcConstants'

_store = Map(
  sapiToken: Map()
  organizations: List()
  sapiUrl: ''
  kbc: Map() # contains - projectBaseUrl, admin (object)
)

ApplicationStore =

  getSapiToken: ->
    _store.getIn [ 'sapiToken']

  getSapiTokenString: ->
    _store.getIn [ 'sapiToken', 'token' ]

  getSapiUrl: ->
    _store.get 'sapiUrl'

  getOrganizations: ->
    _store.get 'organizations'

  getMaintainers: ->
    _store.get 'maintainers'

  getTokenStats: ->
    _store.get 'tokenStats'

  getCurrentProjectId: ->
    _store.getIn ['sapiToken', 'owner', 'id']

  getCurrentProject: ->
    _store.getIn ['sapiToken', 'owner']

  getCurrentAdmin: ->
    _store.getIn ['kbc', 'admin']

  getProjectBaseUrl: ->
    _store.getIn ['kbc', 'projectBaseUrl']

  getScriptsBasePath: ->
    _store.getIn ['kbc', 'scriptsBasePath']

  getProjectPageUrl: (path) ->
    @getProjectBaseUrl() + '/' + path

  getUrlTemplates: ->
    _store.getIn ['kbc', 'urlTemplates']

  getXsrfToken: ->
    _store.getIn ['kbc', 'xsrfToken']

  getCanCreateProject: ->
    _store.getIn ['kbc', 'canCreateProject']

  getKbcVars: ->
    _store.getIn ['kbc']

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
          .set 'maintainers', Immutable.fromJS(action.applicationData.maintainers)
          .set 'tokenStats', Immutable.fromJS(action.applicationData.tokenStats)

module.exports = ApplicationStore
