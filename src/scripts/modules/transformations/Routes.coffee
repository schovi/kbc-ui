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
        path: 'bucket/:configId'
        title: (routerState) ->
          configId = routerState.getIn(['params', 'configId'])
          name = TransformationBucketsStore.get(configId).get 'name'
          name
        nameEdit: (params) ->
          if (parseInt(params.configId) > 0)
            return React.DOM.span null,
              React.createElement ComponentNameEdit,
                componentId: 'transformation'
                configId: params.configId
          else
            return TransformationBucketsStore.get(params.configId).get 'name'
        defaultRouteHandler: TransformationBucket
        requireData: [
          (params) ->
            VersionsActionCreators.loadVersions('transformation', params.configId)
        ]
        poll:
          interval: 10
          action: (params) ->
            JobsActionCreators.loadComponentConfigurationLatestJobs('transformation', params.configId)

        childRoutes: [
          createVersionsPageRoute('transformation', 'configId')
        ,
          name: 'transformationDetail'
          path: 'transformation/:transformationId'
          title: (routerState) ->
            configId = routerState.getIn(['params', 'configId'])
            transformationId = routerState.getIn(['params', 'transformationId'])
            name = TransformationsStore.getTransformation(configId, transformationId).get 'name'
            name
          nameEdit: (params) ->
            if (parseInt(params.transformationId) > 0)
              return React.DOM.span null,
                React.createElement TransformationNameEdit,
                  configId: params.configId
                  rowId: params.transformationId
            else
              return TransformationsStore.getTransformation(params.configId, params.transformationId).get 'name'
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
