

createComponentsIndex = require './pages/ComponentsIndex.coffee'
createNewComponentPage = require './pages/NewComponent.coffee'
createNewComponentButton = require './components/NewComponentButton.coffee'
ComponentReloaderButton = require './components/ComponentsReloaderButton.coffee'

routes =

  extractors:
    name: 'extractors'
    title: 'Extractors'
    defaultRouteHandler: createComponentsIndex('extractor')
    headerButtonsHandler: createNewComponentButton('New Extractor', 'new-extractor')
    reloaderHandler: ComponentReloaderButton
    childRoutes: [
      name: 'new-extractor'
      title: 'New Extractor'
      handler: createNewComponentPage('extractor')
    ]

  writers:
    name: 'writers'
    title: 'Writers'
    defaultRouteHandler: createComponentsIndex('writer')
    headerButtonsHandler: createNewComponentButton('New Writer', 'new-writer')
    reloaderHandler: ComponentReloaderButton
    childRoutes: [
      name: 'new-writer'
      title: 'New Writer'
      handler: createNewComponentPage('writer')
    ]

module.exports = routes