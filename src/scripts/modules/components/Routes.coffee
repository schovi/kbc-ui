

createComponentsIndex = require './react/pages/ComponentsIndex.coffee'
createNewComponentPage = require './react/pages/NewComponent.coffee'
createNewComponentButton = require './react/components/NewComponentButton.coffee'



ComponentReloaderButton = require './react/components/ComponentsReloaderButton.coffee'
IntalledComponentsStore = require './stores/InstalledComponentsStore.coffee'
InstalledComponentsActionsCreators = require './InstalledComponentsActionCreators.coffee'


ExDbActionCreators = require '../ex-db/exDbActionCreators.coffee'
ExDbIndex = require '../ex-db/react/pages/index/Index.coffee'
ExDbQueryDetail = require '../ex-db/react/pages/query-detail/QueryDetail.coffee'
ExDbQueryHeaderButtons = require '../ex-db/react/components/QueryDetailHeaderButtons.coffee'
ExDbIndexHeaderButtons = require '../ex-db/react/components/AddQueryButton.coffee'


routes =

  extractors:
    name: 'extractors'
    title: 'Extractors'
    requireData: ->
      InstalledComponentsActionsCreators.loadComponents()
    defaultRouteHandler: createComponentsIndex('extractor')
    headerButtonsHandler: createNewComponentButton('New Extractor', 'new-extractor')
    reloaderHandler: ComponentReloaderButton
    childRoutes: [
      name: 'new-extractor'
      title: 'New Extractor'
      handler: createNewComponentPage('extractor'),
    ,
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
      headerButtonsHandler: ExDbIndexHeaderButtons
      childRoutes: [
        name: 'ex-db-query'
        path: 'query/:query'
        title: ->
          'query'
        handler: ExDbQueryDetail
        headerButtonsHandler: ExDbQueryHeaderButtons
      ]
    ]

  writers:
    name: 'writers'
    title: 'Writers'
    requireData: ->
      InstalledComponentsActionsCreators.loadComponents()
    defaultRouteHandler: createComponentsIndex('writer')
    headerButtonsHandler: createNewComponentButton('New Writer', 'new-writer')
    reloaderHandler: ComponentReloaderButton
    childRoutes: [
      name: 'new-writer'
      title: 'New Writer'
      handler: createNewComponentPage('writer')
    ]

module.exports = routes