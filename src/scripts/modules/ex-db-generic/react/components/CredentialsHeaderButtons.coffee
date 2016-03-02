React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
storeProvisioning = require '../../storeProvisioning'
actionsProvisioning = require '../../actionsProvisioning'

RoutesStore = require '../../../../stores/RoutesStore'

{Navigation} = require 'react-router'

Loader = React.createFactory(require('kbc-react-components').Loader)

{button, span} = React.DOM
componentId = 'keboola.ex-db-pgsql'
ExDbActionCreators = actionsProvisioning.createActions(componentId)

module.exports = React.createClass
  displayName: 'CredentialsHeaderButtons'
  mixins: [createStoreMixin(storeProvisioning.store), Navigation]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    ExDbStore = storeProvisioning.createStore(componentId, configId)
    currentConfigId: configId
    isEditing: ExDbStore.isEditingCredentials()
    isSaving: ExDbStore.isSavingCredentials()

  _handleEditStart: ->
    ExDbActionCreators.editCredentials @state.currentConfigId

  _handleCancel: ->
    ExDbActionCreators.cancelCredentialsEdit @state.currentConfigId

  _handleCreate: ->
    ExDbActionCreators
    .saveCredentialsEdit @state.currentConfigId

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
          onClick: @_handleCreate
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
          ' Edit Credentials'
