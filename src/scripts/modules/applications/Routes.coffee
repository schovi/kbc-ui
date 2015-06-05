React = require 'react'
Index = require './react/pages/apps-index/AppsIndex'
geneeaApp = require './modules/geneea/react/pages/index/Index'
geneeaAppDetail = require './modules/geneea/react/pages/detail/Detail'
installedComponentsActions =  require '../components/InstalledComponentsActionCreators'
installedComponentsStore =  require '../components/stores/InstalledComponentsStore'
geneeaDetailHeader = require './modules/geneea/react/components/detailHeaderButtons'
routes =
  name: 'applications'
  title: 'Applications'
  defaultRouteHandler: Index
  childRoutes: [
    name: 'kbc-app-geneea'
    path: 'geneea'
    title: 'Geneea'
    defaultRouteHandler: geneeaApp
    requireData: [
      (params) ->
        installedComponentsActions.loadComponents()
    ]
    childRoutes: [
      name: 'kbc-app-geneea-detail'
      path: ':config'
      title: (routerState) ->
        configId = routerState.getIn ['params', 'config']
        config = installedComponentsStore.getConfig 'geneea-topic-detection', configId
        "Geneea Topic Detection - #{config.get('name')}"
      handler: geneeaAppDetail
      headerButtonsHandler: geneeaDetailHeader
      requireData: [
        (params) ->
          installedComponentsActions.loadComponentConfigData("geneea-topic-detection", params.config)
      ]

    ]

  ]


module.exports = routes
