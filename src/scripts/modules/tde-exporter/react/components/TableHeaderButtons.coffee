React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
PureRenderMixin = require('react/addons').addons.PureRenderMixin
{Map} = require 'immutable'

RoutesStore = require '../../../../stores/RoutesStore'
InstalledComponentsActions = require '../../../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../../../components/stores/InstalledComponentsStore'
EditButtons = require '../../../../react/common/EditButtons'

componentId = 'tde-exporter'
module.exports = React.createClass
  displayName: 'tdetablebuttons'

  mixins: [createStoreMixin(InstalledComponentsStore), PureRenderMixin]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    tableId = RoutesStore.getCurrentRouteParam('tableId')
    configData = InstalledComponentsStore.getConfigData(componentId, configId)

    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    columnsTypes = configData.getIn(['parameters', 'typedefs', tableId], Map())

    #state
    configId: configId
    tableId: tableId
    columnsTypes: columnsTypes
    localState: localState
    configData: configData
    isEditing: !! localState.getIn(['editing',tableId])


  render: ->
    React.createElement EditButtons,
      isEditing: @state.isEditing
      isSaving: false
      isDisabled: false
      editLabel: 'Edit'
      cancelLabel: 'Cancel'
      saveLabel: 'Save'
      onCancel: @_cancel
      onSave: @_save
      onEditStart: @_editStart

  _cancel: ->
    path = ['editing', @state.tableId]
    @_updateLocalState(path, null)

  _save: ->

  _editStart: ->
    path = ['editing', @state.tableId]
    @_updateLocalState(path, @state.columnsTypes)


  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
