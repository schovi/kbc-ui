React = require 'react'

IntalledComponentsStore = require './stores/InstalledComponentsStore'
InstalledComponentsActions = require './InstalledComponentsActionCreators'
GenericDetail = require './react/pages/GenericDetail'
ComponentNameEdit = require './react/components/ComponentName'

ComponentsStore = require './stores/ComponentsStore'
JobsActionCreators = require '../jobs/ActionCreators'

module.exports = (componentType) ->
  name: 'generic-detail-' + componentType
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
  ]
  poll:
    interval: 10
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs(params.component, params.config)