React = require 'react'
TransformationsIndex = require('./react/pages/transformations-index/TransformationsIndex')
TransformationBucket = require('./react/pages/transformation-bucket/TransformationBucket')
InstalledComponentsActionCreators = require('./../components/InstalledComponentsActionCreators')


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
