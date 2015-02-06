React = require 'react'
TransformationsIndex = require('./react/pages/transformations-index/TransformationsIndex.coffee')

routes =
      name: 'transformations'
      title: 'Transformations'
      defaultRouteHandler: TransformationsIndex

module.exports = routes
