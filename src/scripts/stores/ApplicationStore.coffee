Dispatcher = require('../Dispatcher')
Immutable = require('immutable')
{Map, List} = Immutable
Constants = require '../constants/KbcConstants'
StoreUtils = require '../utils/StoreUtils'
composeLimits = require('./composeLimits').default

_store = Map(
  sapiToken: Map()
  organizations: List()
  sapiUrl: ''
  kbc: Map() # contains - projectBaseUrl, admin (object)
)

ApplicationStore = StoreUtils.createStore

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

  getNotifications: ->
    Map
      url: @getUrlTemplates().get 'notifications'
      unreadCount: _store.getIn ['notifications', 'unreadCount']
      isEnabled: true

  getProjectTemplates: ->
    _store.get 'projectTemplates'

  getLimits: ->
    composeLimits @getSapiToken().getIn(['owner', 'limits']), @getSapiToken().getIn(['owner', 'metrics'])

  getLimitsOverQuota: ->
    @getLimits()
    .map (section) -> section.get('limits').map((limits) -> limits.set('section', section.get('title')))
    .flatten 1
    .filter (limit) -> limit.get('isAlarm')

  getTokenStats: ->
    _store.get 'tokenStats'

  getCurrentProjectId: ->
    _store.getIn ['sapiToken', 'owner', 'id']

  getCurrentProject: ->
    _store.getIn ['sapiToken', 'owner']

  getCurrentProjecFeatures: ->
    @getCurrentProject().get 'features'

  getCurrentAdmin: ->
    _store.getIn ['kbc', 'admin']

  hasCurrentAdminFeature: (feature) ->
    features = @getCurrentAdmin().get 'features'
    features.includes(feature)

  getProjectBaseUrl: ->
    _store.getIn ['kbc', 'projectBaseUrl']

  getScriptsBasePath: ->
    _store.getIn ['kbc', 'scriptsBasePath']

  getProjectPageUrl: (path) ->
    @getProjectBaseUrl() + '/' + path

  getSapiTableUrl: (tableId) ->
    @getProjectBaseUrl() + "/storage#/tables/#{tableId}"

  getSapiBucketUrl: (bucketId) ->
    @getProjectBaseUrl() + "/storage#/buckets/#{bucketId}"

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
          .set 'notifications', Immutable.fromJS(action.applicationData.notifications)
          .set 'projectTemplates', Immutable.fromJS(action.applicationData.projectTemplates)

module.exports = ApplicationStore
