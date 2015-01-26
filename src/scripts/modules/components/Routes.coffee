createComponentsIndex = require './react/pages/ComponentsIndex.coffee'
createNewComponentPage = require './react/pages/NewComponent.coffee'
createNewComponentButton = require './react/components/NewComponentButton.coffee'


ComponentReloaderButton = require './react/components/ComponentsReloaderButton.coffee'
IntalledComponentsStore = require './stores/InstalledComponentsStore.coffee'
InstalledComponentsActionsCreators = require './InstalledComponentsActionCreators.coffee'

exDbRoutes = require '../ex-db/exDbRoutes.coffee'
exGdriveGoogleRoutes = require '../ex-google-drive/exGdriveRoutes.coffee'
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
