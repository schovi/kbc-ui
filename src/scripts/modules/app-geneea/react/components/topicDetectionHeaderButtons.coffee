React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'

RoutesStore = require '../../../../stores/RoutesStore'

EditButtons = React.createFactory(require '../../../../react/common/EditButtons')
InstalledComponentsStore = require '../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../components/InstalledComponentsActionCreators'

module.exports = React.createClass
  displayName: 'GeneeaDetailHeaderButton'
  mixins: [createStoreMixin(InstalledComponentsStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    componentId = 'geneea-topic-detection'

    componentId: componentId
    configId: configId
    isEditing: InstalledComponentsStore.getEditingConfigData(componentId, configId)
    isSaving: InstalledComponentsStore.getSavingConfigData(componentId, configId)
    isValid: true #TODO: validation!

  _handleEditStart: ->
    InstalledComponentsActions.startEditComponentConfigData(@state.componentId, @state.configId)

  _handleCancel: ->
    InstalledComponentsActions.cancelEditComponentConfigData(@state.componentId, @state.configId)

  _handleCreate: ->
    InstalledComponentsActions.saveComponentConfigData(@state.componentId, @state.configId)

  render: ->
    EditButtons
      isEditing: @state.isEditing
      isSaving: @state.isSaving
      isDisabled: !@state.isValid
      onCancel: @_handleCancel
      onSave: @_handleCreate
      onEditStart: @_handleEditStart
