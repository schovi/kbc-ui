React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ComponentsStore = require '../../../stores/ComponentsStore'
InstalledComponentsStore = require '../../../stores/InstalledComponentsStore.coffee'
FormHeader = React.createFactory(require '../new-component-form/FormHeader')
AppUsageInfo = React.createFactory(require '../new-component-form/AppUsageInfo.coffee')
VendorInfo = React.createFactory(require './VendorInfo.coffee')
ComponentDescription = React.createFactory(require './ComponentDescription.coffee')
ConfigurationRow = require('../ConfigurationRow.jsx').default
Immutable = require 'immutable'

{div, label, h3} = React.DOM

module.exports = React.createClass
  displayName: 'ComponentDetail'
  mixins: [createStoreMixin(ComponentsStore, InstalledComponentsStore)]

  getStateFromStores: ->
    componentId = RoutesStore.getCurrentRouteParam('component')
    component = ComponentsStore.getComponent(componentId)

    if (InstalledComponentsStore.getDeletingConfigurations())
      deletingConfigurations = InstalledComponentsStore.getDeletingConfigurations()
    else
      deletingConfigurations = Immutable.Map()

    componentWithConfigurations = InstalledComponentsStore.getComponent(component.get('id'))
    configurations = Immutable.Map()
    if componentWithConfigurations
      configurations = componentWithConfigurations.get("configurations", Immutable.Map())

    state =
      component: component
      configurations: configurations
      deletingConfigurations: deletingConfigurations.get(component.get('id'), Immutable.Map())
    state

  render: ->
    div className: 'container-fluid kbc-main-content',
      FormHeader
        component: @state.component
        withButtons: false
      div className: "row",
        @_renderVendorInfo() if @_is3rdPartyApp()
        @_renderAppUsageInfo() if @_is3rdPartyApp()
        @_renderDescription() if @state.component.get('longDescription')
        @_renderConfigurations()

  _renderDescription: ->
    ComponentDescription
      component: @state.component

  _renderAppUsageInfo: ->
    AppUsageInfo
      component: @state.component

  _renderVendorInfo: ->
    VendorInfo
      component: @state.component

  _is3rdPartyApp: ->
    @state.component.get('flags').contains('3rdParty')

  _renderConfigurations: ->
    state = @state
    if @state.configurations.count()
      div className: "table table-hover",
        div clasName: "thead",
          h3, "Configurations"
        div className: "tbody",
          @state.configurations.map((configuration) ->
            React.createElement(ConfigurationRow,
              config: configuration,
              componentId: state.component.get('id'),
              isDeleting: state.deletingConfigurations.has(configuration.get('id')),
              key: configuration.get('id')
            )
          )
    else
      div className: "tbody",
        "No configurations"
