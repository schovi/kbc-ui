React = require 'react'

TransformationsIndex = require('./react/pages/transformations-index/TransformationsIndex')
TransformationBucket = require('./react/pages/transformation-bucket/TransformationBucket')
TransformationDetail = require('./react/pages/transformation-detail/TransformationDetail')
TransformationGraph = require('./react/pages/transformation-graph/TransformationGraph')
Sandbox = require('./react/pages/sandbox/Sandbox').default
InstalledComponentsActionCreators = require('./../components/InstalledComponentsActionCreators')
TransformationsActionCreators = require('./ActionCreators')
VersionsActionCreators = require('../components/VersionsActionCreators')
ProvisioningActionCreators = require('../provisioning/ActionCreators')
StorageActionCreators = require('../components/StorageActionCreators')
TransformationsIndexReloaderButton = require './react/components/TransformationsIndexReloaderButton'
TransformationBucketButtons = require './react/components/TransformationBucketButtons'
TransformationListButtons = require('./react/components/TransformationsListButtons').default
TransformationBucketsStore = require  './stores/TransformationBucketsStore'
TransformationsStore = require  './stores/TransformationsStore'
createVersionsPageRoute = require('../../modules/components/utils/createVersionsPageRoute').default
ComponentNameEdit = require '../components/react/components/ComponentName'
TransformationNameEdit = require './react/components/TransformationNameEditField'
ApplicationsStore = require '../../stores/ApplicationStore'
JobsActionCreators = require '../jobs/ActionCreators'

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
          name
        nameEdit: (params) ->
          if (parseInt(params.bucketId) > 0)
            return React.DOM.span null,
              React.createElement ComponentNameEdit,
                componentId: 'transformation'
                configId: params.bucketId
          else
            return TransformationBucketsStore.get(params.bucketId).get 'name'
        defaultRouteHandler: TransformationBucket
        headerButtonsHandler: TransformationListButtons
        requireData: [
          (params) ->
            VersionsActionCreators.loadVersions('transformation', params.bucketId)
        ]
        poll:
          interval: 10
          action: (params) ->
            JobsActionCreators.loadComponentConfigurationLatestJobs('transformation', params.bucketId)

        childRoutes: [
          createVersionsPageRoute('transformation', 'bucketId')
        ,
          name: 'transformationDetail'
          path: 'transformation/:transformationId'
          title: (routerState) ->
            bucketId = routerState.getIn(['params', 'bucketId'])
            transformationId = routerState.getIn(['params', 'transformationId'])
            name = TransformationsStore.getTransformation(bucketId, transformationId).get 'name'
            name
          nameEdit: (params) ->
            if (parseInt(params.transformationId) > 0)
              return React.DOM.span null,
                React.createElement TransformationNameEdit,
                  configId: params.bucketId
                  rowId: params.transformationId
            else
              return TransformationsStore.getTransformation(params.bucketId, params.transformationId).get 'name'
          defaultRouteHandler: TransformationDetail
          requireData: [
            ->
              StorageActionCreators.loadTables()
              StorageActionCreators.loadBuckets()
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
            if (ApplicationsStore.getSapiToken().getIn(['owner', 'hasRedshift']))
              ProvisioningActionCreators.loadRedshiftSandboxCredentials()
        ,
          ->
            if (ApplicationsStore.getSapiToken().getIn(['owner', 'hasSnowflake']))
              ProvisioningActionCreators.loadSnowflakeSandboxCredentials()
        ,
          ->
            StorageActionCreators.loadBuckets()
        ,
          ->
            StorageActionCreators.loadTables()

        ]
      ]

module.exports = routes
