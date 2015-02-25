React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ComponentsStore = require '../../../stores/ComponentsStore'
NewConfigurationsStore = require '../../../stores/NewConfigurationsStore'

NewConfigurationsActionCreators = require '../../../NewConfigurationsActionCreators'

DefaultForm = require './DefaultForm'
GoodDataWriterForm = require './GoodDataWriterForm'


{div} = React.DOM


module.exports = React.createClass
  displayName: 'NewComponentForm'
  mixins: [createStoreMixin(NewConfigurationsStore)]

  getStateFromStores: ->
    componentId = RoutesStore.getCurrentRouteParam('componentId')
    component: ComponentsStore.getComponent(componentId)
    configuration: NewConfigurationsStore.getConfiguration(componentId)
    isValid: NewConfigurationsStore.isValidConfiguration(componentId)
    isSaving: NewConfigurationsStore.isSavingConfiguration(componentId)

  _handleReset: ->
    NewConfigurationsActionCreators.resetConfiguration(@state.component.get 'id')

  _handleChange: (newConfiguration) ->
    NewConfigurationsActionCreators.updateConfiguration(@state.component.get('id'), newConfiguration)

  _handleSave: ->
    NewConfigurationsActionCreators.saveConfiguration(@state.component.get('id'))

  render: ->
    div className: 'container-fluid kbc-main-content',
      React.createElement @_getFormHandler(),
        component: @state.component
        configuration: @state.configuration
        isValid: @state.isValid
        isSaving: @state.isSaving
        onCancel: @_handleReset
        onChange: @_handleChange
        onSave: @_handleSave

  _getFormHandler: ->
    switch @state.component.get('id')
      when 'gooddata-writer' then GoodDataWriterForm
      else DefaultForm


