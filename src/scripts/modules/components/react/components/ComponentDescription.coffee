React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
InstalledComponentsStore = require '../../stores/InstalledComponentsStore'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators'

InlineEditArea = React.createFactory(require '../../../../react/common/InlineEditArea')

{button, span} = React.DOM

FIELD_NAME = 'description'

module.exports = React.createClass
  displayName: 'ComponentDescription'
  mixins: [createStoreMixin(InstalledComponentsStore)]
  propTypes:
    componentId: React.PropTypes.string.isRequired
    configId: React.PropTypes.string.isRequired

  getStateFromStores: ->
    value: InstalledComponentsStore.getConfig(@props.componentId, @props.configId).get FIELD_NAME
    editValue: InstalledComponentsStore.getEditingConfig @props.componentId, @props.configId, FIELD_NAME
    isEditing: InstalledComponentsStore.isEditingConfig @props.componentId, @props.configId, FIELD_NAME
    isSaving: InstalledComponentsStore.isSavingConfig @props.componentId, @props.configId, FIELD_NAME

  _handleEditStart: ->
    InstalledComponentsActionCreators.startConfigurationEdit(@props.componentId, @props.configId, FIELD_NAME)

  _handleEditCancel: ->
    InstalledComponentsActionCreators.cancelConfigurationEdit(@props.componentId, @props.configId, FIELD_NAME)

  _handleEditChange: (newValue) ->
    InstalledComponentsActionCreators.updateEditingConfiguration(
      @props.componentId,
      @props.configId,
      FIELD_NAME,
      newValue
    )

  _handleEditSubmit: ->
    InstalledComponentsActionCreators.saveConfigurationEdit(@props.componentId, @props.configId, FIELD_NAME)

  render: ->
    InlineEditArea
      text: if @state.isEditing then @state.editValue else @state.value
      placeholder: 'Describe the component ...'
      isSaving: @state.isSaving
      isEditing: @state.isEditing
      onEditStart: @_handleEditStart
      onEditCancel: @_handleEditCancel
      onEditChange: @_handleEditChange
      onEditSubmit: @_handleEditSubmit

