createComponentsIndex = require './react/pages/ComponentsIndex'
createNewComponentPage = require './react/pages/NewComponent'
createNewComponentButton = require './react/components/NewComponentButton'


ComponentReloaderButton = require './react/components/ComponentsReloaderButton'
IntalledComponentsStore = require './stores/InstalledComponentsStore'
InstalledComponentsActionsCreators = require './InstalledComponentsActionCreators'

exDbRoutes = require '../ex-db/exDbRoutes'
exGdriveGoogleRoutes = require '../ex-google-drive/exGdriveRoutes'
exGanalRoutes = require '../ex-google-analytics/exGanalRoutes'
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
      exDbRoutes
    ,
      exGdriveGoogleRoutes
    ,
      exGanalRoutes
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
