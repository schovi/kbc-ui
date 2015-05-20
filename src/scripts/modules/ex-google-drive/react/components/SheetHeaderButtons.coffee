React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ExGdriveStore = require '../../exGdriveStore'
RoutesStore = require '../../../../stores/RoutesStore'
ExGdriveActionCreators = require '../../exGdriveActionCreators'

Loader = React.createFactory(require('kbc-react-components').Loader)

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'CredentialsHeaderButtons'
  mixins: [createStoreMixin(ExGdriveStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    sheetId = RoutesStore.getCurrentRouteParam 'sheetId'
    fileId = RoutesStore.getCurrentRouteParam 'fileId'
    currentConfigId: configId
    sheetId: sheetId
    fileId: fileId
    isEditing: ExGdriveStore.isEditingSheet configId, fileId, sheetId
    isSaving: ExGdriveStore.isSavingSheet configId, fileId, sheetId

  _handleEditStart: ->
    ExGdriveActionCreators.editSheetStart @state.currentConfigId, @state.fileId, @state.sheetId

  _handleCancel: ->
    ExGdriveActionCreators.cancelSheetEdit @state.currentConfigId, @state.fileId, @state.sheetId

  _handleUpdate: ->
    ExGdriveActionCreators.saveSheetEdit @state.currentConfigId, @state.fileId, @state.sheetId

  render: ->
    if @state.isEditing
      React.DOM.div className: 'kbc-buttons',
        if @state.isSaving
          Loader()
        button
          className: 'btn btn-link'
          disabled: @state.isSaving
          onClick: @_handleCancel
        ,
          'Cancel'
        button
          className: 'btn btn-success'
          disabled: @state.isSaving
          onClick: @_handleUpdate
        ,
          'Save'
    else
      React.DOM.div null,
        button
          className: 'btn btn-success'
          disabled: @state.isSaving
          onClick: @_handleEditStart
        ,
          span className: 'fa fa-edit'
          ' Edit'
