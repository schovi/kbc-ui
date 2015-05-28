React = require 'react'
Index = require './react/pages/apps-index/AppsIndex'
geneeaApp = require './modules/geneea/react/pages/index/Index'

routes =
  name: 'applications'
  title: 'Applications'
  handler: Index
  childRoutes: [
    name: 'kbc-app-geneea'
    path: 'geneea'
    title: 'Geneea'
    handler: geneeaApp
    # requireData: [
    #   ->
    #     StorageActionCreators.loadTables()
    # ]

  ]


module.exports = routes
