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
injectProps = require('../components/react/injectProps').default
Immutable = require('immutable')

routes =
      name: 'transformations'
      title: 'Transformations'
      defaultRouteHandler: TransformationsIndex
      reloaderHandler: injectProps(allowRefresh: true)(TransformationsIndexReloaderButton)
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
        path: 'bucket/:config'
        title: (routerState) ->
          configId = routerState.getIn(['params', 'config'])
          name = TransformationBucketsStore.get(configId).get 'name'
          name
        nameEdit: (params) ->
          if (parseInt(params.config) > 0)
            return React.DOM.span null,
              React.createElement ComponentNameEdit,
                componentId: 'transformation'
                configId: params.config
          else
            return TransformationBucketsStore.get(params.config).get 'name'
        defaultRouteHandler: TransformationBucket
        reloaderHandler: TransformationsIndexReloaderButton
        requireData: [
          (params) ->
            VersionsActionCreators.loadVersions('transformation', params.config)
        ]
        poll:
          interval: 10
          action: (params) ->
            JobsActionCreators.loadComponentConfigurationLatestJobs('transformation', params.config)

        childRoutes: [
          createVersionsPageRoute('transformation', 'config')
        ,
          name: 'transformationDetail'
          path: 'transformation/:row'
          title: (routerState) ->
            configId = routerState.getIn(['params', 'config'])
            transformationId = routerState.getIn(['params', 'row'])
            name = TransformationsStore.getTransformation(configId, transformationId).get 'name'
            name
          nameEdit: (params) ->
            if (parseInt(params.row) > 0)
              return React.DOM.span null,
                React.createElement TransformationNameEdit,
                  configId: params.config
                  rowId: params.row
            else
              return TransformationsStore.getTransformation(params.config, params.row).get 'name'
          defaultRouteHandler: TransformationDetail
          reloaderHandler: TransformationsIndexReloaderButton
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
            if (ApplicationsStore.hasCurrentAdminFeature('docker-sandbox'))
              ProvisioningActionCreators.loadRStudioSandboxCredentials()
        ,
          ->
            if (ApplicationsStore.hasCurrentAdminFeature('docker-sandbox'))
              ProvisioningActionCreators.loadJupyterSandboxCredentials()
        ,
          ->
            StorageActionCreators.loadBuckets()
        ,
          ->
            StorageActionCreators.loadTables()

        ]
      ]

module.exports = routes
