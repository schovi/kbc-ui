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
ComponentEmptyState = require('../../components/ComponentEmptyState').default
ComponentInfo = React.createFactory(require('../../components/ComponentInfo').default)


{div, label, h3, h2} = React.DOM

module.exports = React.createClass
  displayName: 'ComponentDetail'
  mixins: [createStoreMixin(ComponentsStore, InstalledComponentsStore)]
  propTypes:
    component: React.PropTypes.string

  getStateFromStores: ->
    componentId = if @props.component then @props.component else RoutesStore.getCurrentRouteParam('component')
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
    ComponentInfo
      component: @state.component
    ,
      div className: "row",
        @_renderConfigurations()

  _renderConfigurations: ->
    state = @state
    if @state.configurations.count()
      div null,
        div className: "kbc-header",
          div className: "kbc-title",
            h2 null, "Configurations"
        div className: "table table-hover",
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
      React.createElement ComponentEmptyState, null,
        "No configurations"
