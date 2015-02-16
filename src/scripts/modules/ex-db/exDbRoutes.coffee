
IntalledComponentsStore = require '../components/stores/InstalledComponentsStore'

ExDbActionCreators = require '../ex-db/exDbActionCreators'
ExDbIndex = require '../ex-db/react/pages/index/Index'
ExDbCredentials = require '../ex-db/react/pages/credentials/Credentials'
ExDbQueryDetail = require '../ex-db/react/pages/query-detail/QueryDetail'
ExDbNewQuery = require '../ex-db/react/pages/new-query/NewQuery'
ExDbNewQueryHeaderButtons = require '../ex-db/react/components/NewQueryHeaderButtons'
ExDbQueryHeaderButtons = require '../ex-db/react/components/QueryDetailHeaderButtons'
ExDbCredentialsHeaderButtons = require '../ex-db/react/components/CredentialsHeaderButtons'

module.exports =
  name: 'ex-db'
  path: 'ex-db/:config'
  isComponent: true
  requireData: [
    (params) ->
      ExDbActionCreators.loadConfiguration params.config
  ]
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    'Database - ' + IntalledComponentsStore.getConfig('ex-db', configId).get 'name'
  defaultRouteHandler: ExDbIndex
  childRoutes: [
    name: 'ex-db-query'
    path: 'query/:query'
    title: ->
      'query'
    handler: ExDbQueryDetail
    headerButtonsHandler: ExDbQueryHeaderButtons
  ,
    name: 'ex-db-new-query'
    path: 'new-query'
    title: ->
      'New query'
    handler: ExDbNewQuery
    headerButtonsHandler: ExDbNewQueryHeaderButtons
  ,
    name: 'ex-db-credentials'
    path: 'credentials'
    title: ->
      'Credentials'
    handler: ExDbCredentials
    headerButtonsHandler: ExDbCredentialsHeaderButtons
  ]
