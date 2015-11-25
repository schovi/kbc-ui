React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ComponentsStore = require '../../../stores/ComponentsStore'
FormHeader = React.createFactory(require '../new-component-form/FormHeader')
AppUsageInfo = React.createFactory(require '../new-component-form/AppUsageInfo.coffee')
VendorInfo = React.createFactory(require './VendorInfo.coffee')
ComponentDescription = React.createFactory(require './ComponentDescription.coffee')

{div, label} = React.DOM


module.exports = React.createClass
  displayName: 'ComponentDetail'
  mixins: [createStoreMixin(ComponentsStore)]

  getStateFromStores: ->
    componentId = RoutesStore.getCurrentRouteParam('componentId')
    component: ComponentsStore.getComponent(componentId)

  render: ->
    div className: 'container-fluid kbc-main-content',
      FormHeader
        component: @state.component
        withButtons: false
      div className: "row",
        @_renderVendorInfo() if @_is3rdPartyApp()
        @_renderAppUsageInfo() if @_is3rdPartyApp()
        @_renderDescription() if @state.component.get('longDescription')

  _renderContactInfo: ->


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

