React = require 'react'
TransformationsIndex = require('./react/pages/transformations-index/TransformationsIndex')
TransformationBucket = require('./react/pages/transformation-bucket/TransformationBucket')
Sandbox = require('./react/pages/sandbox/Sandbox')
InstalledComponentsActionCreators = require('./../components/InstalledComponentsActionCreators')
TransformationsActionCreators = require('./ActionCreators')
ProvisioningActionCreators = require('../provisioning/ActionCreators')
StorageActionCreators = require('../components/StorageActionCreators')

TransformationsIndexReloaderButton = require './react/components/TransformationsIndexReloaderButton'
TransformationBucketButtons = require './react/components/TransformationBucketButtons'


routes =
      name: 'transformations'
      title: 'Transformations'
      defaultRouteHandler: TransformationsIndex
      reloaderHandler: TransformationsIndexReloaderButton
      headerButtonsHandler: TransformationBucketButtons
      requireData: [
        (params) ->
          TransformationsActionCreators.loadTransformationBuckets()
      ]
      childRoutes: [
        name: 'transformationBucket'
        path: 'bucket/:bucketId'
        title: (routerState) ->
          bucketId = routerState.getIn(['params', 'bucketId'])
          "Bucket " + bucketId
        handler: TransformationBucket
        requireData: [
          (params) ->
            TransformationsActionCreators.loadTransformations(params.bucketId)
        ]
      ,
        name: 'sandbox'
        title: ->
          "Sandbox"
        handler: Sandbox
        requireData: [
          (params) ->
            ProvisioningActionCreators.loadCredentials("mysql", "sandbox")
        ,
          (params) ->
            ProvisioningActionCreators.loadCredentials("redshift", "sandbox")
        ,
          (params) ->
            StorageActionCreators.loadBuckets()
        ,
          (params) ->
            StorageActionCreators.loadTables()

        ]
      ]

module.exports = routes
