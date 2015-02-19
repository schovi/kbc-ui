
React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
InstalledComponentsStore = require '../../stores/InstalledComponentsStore'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators'

{button, span} = React.DOM

module.exports = React.createClass
  displayName: "ComponentEditField"
  mixins: [createStoreMixin(InstalledComponentsStore)]
  propTypes:
    componentId: React.PropTypes.string.isRequired
    configId: React.PropTypes.string.isRequired
    fieldName: React.PropTypes.string.isRequired
    editElement: React.PropTypes.element.isRequired

  getStateFromStores: ->
    value: InstalledComponentsStore.getConfig(@props.componentId, @props.configId).get @props.fieldName
    editValue: InstalledComponentsStore.getEditingConfig @props.componentId, @props.configId, @props.fieldName
    isEditing: InstalledComponentsStore.isEditingConfig @props.componentId, @props.configId, @props.fieldName
    isSaving: InstalledComponentsStore.isSavingConfig @props.componentId, @props.configId, @props.fieldName

  _handleEditStart: ->
    InstalledComponentsActionCreators.startConfigurationEdit(@props.componentId, @props.configId, @props.fieldName)

  _handleEditCancel: ->
    InstalledComponentsActionCreators.cancelConfigurationEdit(@props.componentId, @props.configId, @props.fieldName)

  _handleEditChange: (newValue) ->
    InstalledComponentsActionCreators.updateEditingConfiguration(
      @props.componentId,
      @props.configId,
      @props.fieldName,
      newValue
    )

  _handleEditSubmit: ->
    InstalledComponentsActionCreators.saveConfigurationEdit(@props.componentId, @props.configId, @props.fieldName)

  render: ->
    React.createElement @props.editElement,
      text: if @state.isEditing then @state.editValue else @state.value
      placeholder: 'Describe the component ...'
      isSaving: @state.isSaving
      isEditing: @state.isEditing
      onEditStart: @_handleEditStart
      onEditCancel: @_handleEditCancel
      onEditChange: @_handleEditChange
      onEditSubmit: @_handleEditSubmit

