IntalledComponentsStore = require '../components/stores/InstalledComponentsStore'
StorageActionCreators = require '../components/StorageActionCreators'
ExGanalIndex = require './react/pages/index/Index'
ExGanalActionCreators = require './exGanalActionCreators'
JobsActionCreators = require '../jobs/ActionCreators'

#authorizePage = require './react/pages/authorize/authorize'
#ExGanalSheetHeaderButtons = require './react/components/SheetHeaderButtons'
ExGanalNewQuery = require './react/pages/new-query/NewQuery'
ExGanalQueryDetail = require './react/pages/query-detail/QueryDetail'
NewQueryHandlerButton = require './react/components/NewQueryHeaderButton'
QueryDetailHeaderButtons = require './react/components/QueryDetailHeaderButtons'
ExGanalAuthorize = require './react/pages/authorize/Authorize'
ExGanalProfiles = require './react/pages/profiles/Profiles'
ProfilesHeaderButton = require './react/components/ProfilesHeaderButton'
module.exports =
  name: 'ex-google-analytics'
  path: ':config'
  isComponent: true
  defaultRouteHandler: ExGanalIndex
  requireData: [
      (params) ->
        ExGanalActionCreators.loadConfiguration params.config
    , ->
        StorageActionCreators.loadBuckets()
  ]
  poll:
    interval: 7
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs('ex-google-analytics', params.config)
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    IntalledComponentsStore.getConfig('ex-google-analytics', configId).get 'name'

  childRoutes: [
    name: 'ex-google-analytics-select-profiles'
    path: 'profiles'
    title: 'Select Profiles'
    headerButtonsHandler: ProfilesHeaderButton
    handler: ExGanalProfiles
    requireData: [
      (params) ->
        ExGanalActionCreators.loadProfiles params.config
    ]

  ,
    name: 'ex-google-analytics-query'
    path: 'query/:name'
    title: (routerState) ->
      queryName = routerState.getIn ['params', 'name']
      return "Query #{queryName}"

    handler: ExGanalQueryDetail
    headerButtonsHandler: QueryDetailHeaderButtons

  ,
    name: 'ex-google-analytics-authorize'
    path: 'authorize'
    title: 'Authorize'
    handler: ExGanalAuthorize
  ,
    name: 'ex-google-analytics-new-query'
    path: 'new-query'
    title: 'New Query'
    handler: ExGanalNewQuery
    headerButtonsHandler: NewQueryHandlerButton

  ]
