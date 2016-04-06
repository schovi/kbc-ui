React = require 'react'

IntalledComponentsStore = require './stores/InstalledComponentsStore'
SchemasActionsCreators = require './SchemasActionCreators'
InstalledComponentsActions = require './InstalledComponentsActionCreators'
StorageActions = require './StorageActionCreators'
GenericDetail = require('./react/pages/GenericDetail').default
GenericDockerDetail = require('./react/pages/GenericDockerDetail').default
ComponentNameEdit = require './react/components/ComponentName'
{GENERIC_DETAIL_PREFIX} = require('./Constants').Routes
ComponentDetailLink = require '../../react/common/ComponentDetailLink'
ComponentDetail = require '../components/react/pages/component-detail/ComponentDetail'

ComponentsStore = require './stores/ComponentsStore'
JobsActionCreators = require '../jobs/ActionCreators'
ComponentsActionCreators = require './ComponentsActionCreators'

OauthUtils = require '../oauth-v2/OauthUtils'

module.exports = (componentType) ->
  name: GENERIC_DETAIL_PREFIX + componentType
  title: (routerState) ->
    componentId = routerState.getIn ['params', 'component']
    ComponentsStore.getComponent(componentId).get 'name'
  path: ':component'
  defaultRouteHandler: ComponentDetail
  requireData: (params) ->
    ComponentsActionCreators.loadComponent params.component
  childRoutes: [
    name: 'generic-detail-' + componentType + '-config'
    title: (routerState) ->
      configId = routerState.getIn ['params', 'config']
      component = routerState.getIn ['params', 'component']
      component + ' - ' + IntalledComponentsStore.getConfig(component, configId).get 'name'
    nameEdit: (params) ->
      React.DOM.span null,
        React.createElement ComponentNameEdit,
          componentId: params.component
          configId: params.config
    defaultRouteHandler: GenericDetail
    path: ":config"
    isComponent: true
    requireData: [
      (params) ->
        InstalledComponentsActions.loadComponentConfigData(params.component, params.config).then ->
          if ComponentsStore.getComponent(params.component).get('flags').includes('genericDockerUI-authorization')
            OauthUtils.loadCredentialsFromConfig(params.component, params.config)
    ,
      ->
        StorageActions.loadTables()
    ,
      ->
        StorageActions.loadBuckets()
    ,
      (params) ->
        SchemasActionsCreators.loadSchema params.component
    ]
    poll:
      interval: 10
      action: (params) ->
        JobsActionCreators.loadComponentConfigurationLatestJobs(params.component, params.config)
    childRoutes: [
      OauthUtils.createRedirectRoute(
        'generic-' + componentType + '-oauth-redirect'
      , 'generic-detail-' + componentType + '-config'
      , (params) -> {component: params.component, config: params.config}
      )
    ]
  ]
