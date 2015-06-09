React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
validation = require './validation'
RoutesStore = require '../../../../stores/RoutesStore'

EditButtons = React.createFactory(require '../../../../react/common/EditButtons')
InstalledComponentsStore = require '../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../components/InstalledComponentsActionCreators'

module.exports = (componentId) ->
  React.createClass
    displayName: 'GeneeaDetailHeaderButton'
    mixins: [createStoreMixin(InstalledComponentsStore)]

    componentWillReceiveProps: ->
      @setState(@getStateFromStores())

    getStateFromStores: ->
      configId = RoutesStore.getCurrentRouteParam 'config'
      componentId = componentId
      editingData = InstalledComponentsStore.getEditingConfigData(componentId, configId)

      componentId: componentId
      configId: configId
      isEditing: editingData
      isSaving: InstalledComponentsStore.getSavingConfigData(componentId, configId)
      isValid: validation(componentId).isComplete(editingData)

    _handleEditStart: ->
      InstalledComponentsActions.startEditComponentConfigData(@state.componentId, @state.configId)

    _handleCancel: ->
      InstalledComponentsActions.cancelEditComponentConfigData(@state.componentId, @state.configId)

    _handleCreate: ->
      InstalledComponentsActions.saveComponentConfigData(@state.componentId, @state.configId)

    render: ->
      EditButtons
        editLabel: 'Setup'
        isEditing: @state.isEditing
        isSaving: @state.isSaving
        isDisabled: !@state.isValid
        onCancel: @_handleCancel
        onSave: @_handleCreate
        onEditStart: @_handleEditStart
