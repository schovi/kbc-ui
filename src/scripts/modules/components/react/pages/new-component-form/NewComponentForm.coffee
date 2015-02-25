React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ComponentsStore = require '../../../stores/ComponentsStore'
NewConfigurationsStore = require '../../../stores/NewConfigurationsStore'

NewConfigurationsActionCreators = require '../../../NewConfigurationsActionCreators'

DefaultForm = React.createFactory(require './DefaultForm')


{div} = React.DOM


module.exports = React.createClass
  displayName: 'NewComponentForm'
  mixins: [createStoreMixin(NewConfigurationsStore)]

  getStateFromStores: ->
    component: ComponentsStore.getComponent(RoutesStore.getCurrentRouteParam('componentId'))
    configuration: NewConfigurationsStore.getConfiguration(RoutesStore.getCurrentRouteParam('componentId'))

  _handleReset: ->
    NewConfigurationsActionCreators.resetConfiguration(@state.component.get 'id')

  _handleChange: (newConfiguration) ->
    NewConfigurationsActionCreators.updateConfiguration(@state.component.get('id'), newConfiguration)

  render: ->
    div className: 'container-fluid kbc-main-content',
      DefaultForm
        component: @state.component
        configuration: @state.configuration
        onCancel: @_handleReset
        onChange: @_handleChange


