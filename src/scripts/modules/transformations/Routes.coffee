React = require 'react'
TransformationsIndex = require('./react/pages/transformations-index/TransformationsIndex.coffee')
InstalledComponentsActionCreators = require('./../components/InstalledComponentsActionCreators.coffee')

routes =
      name: 'transformations'
      title: 'Transformations'
      defaultRouteHandler: TransformationsIndex
      requireData: [
        (params) ->
          InstalledComponentsActionCreators.loadComponents()
      ]
      

module.exports = routes
