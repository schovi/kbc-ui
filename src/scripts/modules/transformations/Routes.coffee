React = require 'react'

TransformationsIndex = require('./react/pages/transformations-index/TransformationsIndex')
TransformationBucket = require('./react/pages/transformation-bucket/TransformationBucket')
TransformationDetail = require('./react/pages/transformation-detail/TransformationDetail')
Sandbox = require('./react/pages/sandbox/Sandbox')
InstalledComponentsActionCreators = require('./../components/InstalledComponentsActionCreators')
TransformationsActionCreators = require('./ActionCreators')
ProvisioningActionCreators = require('../provisioning/ActionCreators')
StorageActionCreators = require('../components/StorageActionCreators')
TransformationsIndexReloaderButton = require './react/components/TransformationsIndexReloaderButton'
TransformationBucketButtons = require './react/components/TransformationBucketButtons'
TransformationBucketsStore = require  './stores/TransformationBucketsStore'
TransformationsStore = require  './stores/TransformationsStore'

routes =
      name: 'transformations'
      title: 'Transformations'
      defaultRouteHandler: TransformationsIndex
      reloaderHandler: TransformationsIndexReloaderButton
      headerButtonsHandler: TransformationBucketButtons
      requireData: [
        (params) ->
          TransformationsActionCreators.loadTransformationBuckets()
      ,
        ->
          InstalledComponentsActionCreators.loadComponents()
      ]
      childRoutes: [
        name: 'transformationBucket'
        path: 'bucket/:bucketId'
        title: (routerState) ->
          bucketId = routerState.getIn(['params', 'bucketId'])
          name = TransformationBucketsStore.get(bucketId).get 'name'
          "Bucket " + name
        handler: TransformationBucket
        requireData: [
          (params) ->
            TransformationsActionCreators.loadTransformations(params.bucketId)
        ]
        childRoutes: [
          name: 'transformationDetail'
          path: 'transformation/:transformationId'
          title: (routerState) ->
            transformationId = routerState.getIn(['params', 'transformationId'])
            name = TransformationsStore.getTransformation(transformationId).get 'friendlyName'
            "Transformation " + name
          handler: TransformationDetail
          requireData: [
            (params) ->
              TransformationsActionCreators.loadTransformations(params.bucketId)
          ]
        ]
      ,
        name: 'sandbox'
        title: ->
          "Sandbox"
        handler: Sandbox
        requireData: [
          (params) ->
            ProvisioningActionCreators.loadMySqlSandboxCredentials()
        ,
          (params) ->
            ProvisioningActionCreators.loadRedshiftSandboxCredentials()
        ,
          (params) ->
            StorageActionCreators.loadBuckets()
        ,
          (params) ->
            StorageActionCreators.loadTables()

        ]
      ]

module.exports = routes
