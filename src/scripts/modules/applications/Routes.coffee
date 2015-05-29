React = require 'react'
Index = require './react/pages/apps-index/AppsIndex'
geneeaApp = require './modules/geneea/react/pages/index/Index'
installedComponentsActions =  require '../components/InstalledComponentsActionCreators'

routes =
  name: 'applications'
  title: 'Applications'
  defaultRouteHandler: Index
  childRoutes: [
    name: 'kbc-app-geneea'
    path: 'geneea'
    title: 'Geneea'
    handler: geneeaApp
    requireData: [
      (params) ->
        configId = params.configId #not supported now!
        installedComponentsActions.loadComponentConfigData('geneea-topic-detection', configId)
    ]

  ]


module.exports = routes
