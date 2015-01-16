
IntalledComponentsStore = require '../components/stores/InstalledComponentsStore.coffee'

ExDbActionCreators = require '../ex-db/exDbActionCreators.coffee'
ExDbIndex = require '../ex-db/react/pages/index/Index.coffee'
ExDbCredentials = require '../ex-db/react/pages/credentials/Credentials.coffee'
ExDbQueryDetail = require '../ex-db/react/pages/query-detail/QueryDetail.coffee'
ExDbNewQuery = require '../ex-db/react/pages/new-query/NewQuery.coffee'
ExDbNewQueryHeaderButtons = require '../ex-db/react/components/NewQueryHeaderButtons.coffee'
ExDbQueryHeaderButtons = require '../ex-db/react/components/QueryDetailHeaderButtons.coffee'
ExDbCredentialsHeaderButtons = require '../ex-db/react/components/CredentialsHeaderButtons.coffee'

module.exports =
  name: 'ex-db'
  path: 'ex-db/:config'
  requireData: [
    (params) ->
      ExDbActionCreators.loadConfiguration params.config
  ]
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    'Database extractor - ' + IntalledComponentsStore.getConfig('ex-db', configId).get 'name'
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