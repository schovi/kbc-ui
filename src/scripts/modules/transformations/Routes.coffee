React = require 'react'
TransformationsIndex = require('./react/pages/transformations-index/TransformationsIndex.coffee')
TransformationBucket = require('./react/pages/transformation-bucket/TransformationBucket.coffee')
InstalledComponentsActionCreators = require('./../components/InstalledComponentsActionCreators.coffee')

routes =
      name: 'transformations'
      title: 'Transformations'
      defaultRouteHandler: TransformationsIndex
      requireData: [
        (params) ->
          InstalledComponentsActionCreators.loadComponents()
      ]
      childRoutes: [
        name: 'transformationBucket'
        path: ':bucketId'
        title: (routerState) ->
          bucketId = routerState.getIn(['params', 'bucketId'])
          "Bucket " + bucketId
        handler: TransformationBucket
        #requireData: [
        #  (params) ->
        #    JobsActionCreators.loadJobDetail(parseInt(params.jobId))
        #]
      ]

module.exports = routes
