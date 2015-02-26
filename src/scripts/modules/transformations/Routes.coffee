React = require 'react'
TransformationsIndex = require('./react/pages/transformations-index/TransformationsIndex')
TransformationBucket = require('./react/pages/transformation-bucket/TransformationBucket')
InstalledComponentsActionCreators = require('./../components/InstalledComponentsActionCreators')
TransformationsActionCreators = require('./ActionCreators')

TransformationsIndexReloaderButton = require './react/components/TransformationsIndexReloaderButton'
NewTransformationBucketButton = require './react/components/NewTransformationBucketButton'


routes =
      name: 'transformations'
      title: 'Transformations'
      defaultRouteHandler: TransformationsIndex
      reloaderHandler: TransformationsIndexReloaderButton
      headerButtonsHandler: NewTransformationBucketButton
      requireData: [
        (params) ->
          TransformationsActionCreators.loadTransformationBuckets()
        
      ]
      childRoutes: [
        name: 'transformationBucket'
        path: ':bucketId'
        title: (routerState) ->
          bucketId = routerState.getIn(['params', 'bucketId'])
          "Bucket " + bucketId
        handler: TransformationBucket
        requireData: [
          (params) ->
            TransformationsActionCreators.loadTransformations(params.bucketId)
        ]
      ]

module.exports = routes
