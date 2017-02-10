React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ComponentsStore = require '../../../stores/ComponentsStore'
InstalledComponentsStore = require '../../../stores/InstalledComponentsStore.coffee'
ApplicationStore = require '../../../../../stores/ApplicationStore'

AppUsageInfo = React.createFactory(require '../new-component-form/AppUsageInfo.coffee')
VendorInfo = React.createFactory(require './VendorInfo.coffee')
ComponentDescription = React.createFactory(require './ComponentDescription.coffee')
ConfigurationRow = require('../ConfigurationRow.jsx').default
Immutable = require 'immutable'
ComponentEmptyState = require('../../components/ComponentEmptyState').default
AddComponentConfigurationButton = React.createFactory(require '../../components/AddComponentConfigurationButton')

FormHeader = require('../new-component-form/FormHeader')
VendorInfo = require('../component-detail/VendorInfo')
AppUsageInfo = require('../new-component-form/AppUsageInfo')
ComponentDescription = require '../component-detail/ComponentDescription'
contactSupport = require('../../../../../utils/contactSupport').default
MigrationRow = require('../../components/MigrationRow').default

{a, div, label, h3, h2, span, p} = React.DOM

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
    div className: "container-fluid kbc-main-content",
      React.createElement FormHeader,
        component: @state.component
        withButtons: false
      div className: "row",
        div className: "col-md-6",
          React.createElement AppUsageInfo,
            component: @state.component
        div className: "col-md-6",
          React.createElement VendorInfo,
            component: @state.component
      if @_isDeprecated()
        React.createElement MigrationRow,
          componentId: @state.component.get('id')
      if (@state.component.get('longDescription'))
        div className: "row",
          div className: "col-md-12",
            React.createElement ComponentDescription,
              component: @state.component
      @_renderConfigurations()

  _isDeprecated: ->
    return @state.component.get('flags').includes('deprecated')

  _renderConfigurations: ->
    hasRedshift = ApplicationStore.getSapiToken().getIn ['owner', 'hasRedshift']
    needsRedshift = @state.component.get('flags').includes('appInfo.redshiftOnly')

    if needsRedshift and not hasRedshift
      return div className: 'row',
        span {},
          "Redshift is not enabled for this project, please "
        ,
          a {onClick: @_openSupportModal}, "contact us"
        ,
          " to get more info."

    state = @state
    if @state.configurations.count()
      div null,
        div className: "kbc-header",
          div className: "kbc-title",
            h2 null, "Configurations"
            span className: "pull-right",
              AddComponentConfigurationButton
                disabled: @_isDeprecated()
                component: state.component
        div className: "table table-hover",
          div className: "tbody",
            @state.configurations
            .sortBy (configuration) ->
              configuration.get('name').toLowerCase()
            .map((configuration) =>
              React.createElement(ConfigurationRow,
                component: @state.component,
                config: configuration,
                componentId: state.component.get('id'),
                isDeleting: state.deletingConfigurations.has(configuration.get('id')),
                key: configuration.get('id')
              )
            )
    else
      div className: "row kbc-row",
        React.createElement ComponentEmptyState, null,
          p className: "text-center",
            AddComponentConfigurationButton
              disabled: @_isDeprecated()
              label: "Create New Configuration"
              component: state.component

  _openSupportModal: (e) ->
    contactSupport(type: 'project')
    e.preventDefault()
    e.stopPropagation()
