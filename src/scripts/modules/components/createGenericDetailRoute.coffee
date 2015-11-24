React = require 'react'

IntalledComponentsStore = require './stores/InstalledComponentsStore'
InstalledComponentsActions = require './InstalledComponentsActionCreators'
StorageActions = require './StorageActionCreators'
GenericDetail = require('./react/pages/GenericDetail').default
GenericDockerDetail = require('./react/pages/GenericDockerDetail').default
ComponentNameEdit = require './react/components/ComponentName'
{GENERIC_DETAIL_PREFIX} = require('./Constants').Routes

ComponentsStore = require './stores/ComponentsStore'
JobsActionCreators = require '../jobs/ActionCreators'

module.exports = (componentType) ->
  name: GENERIC_DETAIL_PREFIX + componentType
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    component = routerState.getIn ['params', 'component']
    component + ' - ' + IntalledComponentsStore.getConfig(component, configId).get 'name'
  nameEdit: (params) ->
    React.DOM.span null,
      ComponentsStore.getComponent(params.component).get('name')
      ' - '
      React.createElement ComponentNameEdit,
        componentId: params.component
        configId: params.config
  defaultRouteHandler: GenericDetail
  path: ":component/:config"
  isComponent: true
  requireData: [
    (params) ->
      InstalledComponentsActions.loadComponentConfigData params.component, params.config
  ,
    ->
      StorageActions.loadTables()
  ,
    ->
      StorageActions.loadBuckets()
  ]
  poll:
    interval: 10
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs(params.component, params.config)
