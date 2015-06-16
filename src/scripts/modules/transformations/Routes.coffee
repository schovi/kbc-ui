React = require 'react'

TransformationsIndex = require('./react/pages/transformations-index/TransformationsIndex')
TransformationBucket = require('./react/pages/transformation-bucket/TransformationBucket')
TransformationDetail = require('./react/pages/transformation-detail/TransformationDetail')
TransformationGraph = require('./react/pages/transformation-graph/TransformationGraph')
Sandbox = require('./react/pages/sandbox/Sandbox')
InstalledComponentsActionCreators = require('./../components/InstalledComponentsActionCreators')
TransformationsActionCreators = require('./ActionCreators')
ProvisioningActionCreators = require('../provisioning/ActionCreators')
StorageActionCreators = require('../components/StorageActionCreators')
TransformationsIndexReloaderButton = require './react/components/TransformationsIndexReloaderButton'
TransformationBucketButtons = require './react/components/TransformationBucketButtons'
TransformationListButtons = require './react/components/TransformationsListButtons'
TransformationDetailButtons = require './react/components/TransformationDetailButtons'
TransformationBucketsStore = require  './stores/TransformationBucketsStore'
TransformationsStore = require  './stores/TransformationsStore'

routes =
      name: 'transformations'
      title: 'Transformations'
      defaultRouteHandler: TransformationsIndex
      reloaderHandler: TransformationsIndexReloaderButton
      headerButtonsHandler: TransformationBucketButtons
      requireData: [
        ->
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
        defaultRouteHandler: TransformationBucket
        headerButtonsHandler: TransformationListButtons
        requireData: [
          (params) ->
            TransformationsActionCreators.loadTransformations(params.bucketId)
        ]
        childRoutes: [
          name: 'transformationDetail'
          path: 'transformation/:transformationId'
          title: (routerState) ->
            bucketId = routerState.getIn(['params', 'bucketId'])
            transformationId = routerState.getIn(['params', 'transformationId'])
            name = TransformationsStore.getTransformation(bucketId, transformationId).get 'name'
            "Transformation " + name
          defaultRouteHandler: TransformationDetail
          headerButtonsHandler: TransformationDetailButtons
          requireData: [
            ->
              StorageActionCreators.loadTables()
          ]
          childRoutes: [
            name: 'transformationDetailGraph'
            path: 'graph'
            title: (routerState) ->
              "Overview"
            defaultRouteHandler: TransformationGraph
          ]
        ]
      ,
        name: 'sandbox'
        title: ->
          "Sandbox"
        defaultRouteHandler: Sandbox
        requireData: [
          ->
            ProvisioningActionCreators.loadMySqlSandboxCredentials()
        ,
          ->
            ProvisioningActionCreators.loadRedshiftSandboxCredentials()
        ,
          ->
            StorageActionCreators.loadBuckets()
        ,
          ->
            StorageActionCreators.loadTables()

        ]
      ]

module.exports = routes
