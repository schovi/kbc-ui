React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ExDbStore = require '../../exDbStore'
RoutesStore = require '../../../../stores/RoutesStore'
ExDbActionCreators = require '../../exDbActionCreators'
EditButtons = React.createFactory(require '../../../../react/common/EditButtons')



module.exports = React.createClass
  displayName: 'QueryDetailHeaderButtons'
  mixins: [createStoreMixin(ExDbStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    queryId = RoutesStore.getCurrentRouteIntParam 'query'
    currentConfigId: configId
    currentQueryId: queryId
    isEditing: ExDbStore.isEditingQuery configId, queryId
    isSaving: ExDbStore.isSavingQuery configId, queryId
    isValid: ExDbStore.isEditingQueryValid configId, queryId

  _handleEditStart: ->
    ExDbActionCreators.editQuery @state.currentConfigId, @state.currentQueryId

  _handleCancel: ->
    ExDbActionCreators.cancelQueryEdit @state.currentConfigId, @state.currentQueryId

  _handleCreate: ->
    ExDbActionCreators.saveQueryEdit @state.currentConfigId, @state.currentQueryId

  render: ->
    EditButtons
      isEditing: @state.isEditing
      isSaving: @state.isSaving
      isDisabled: !@state.isValid
      onCancel: @_handleCancel
      onSave: @_handleCreate
      onEditStart: @_handleEditStart
