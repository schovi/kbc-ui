React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'

RoutesStore = require '../../../../stores/RoutesStore'

{Navigation} = require 'react-router'

Loader = React.createFactory(require('kbc-react-components').Loader)

{button, span} = React.DOM

module.exports = (componentId, actionsProvisioning, storeProvisioning) ->
  ExDbActionCreators = actionsProvisioning.createActions(componentId)
  React.createClass
    displayName: 'CredentialsHeaderButtons'
    mixins: [createStoreMixin(storeProvisioning.componentsStore), Navigation]

    getStateFromStores: ->
      configId = RoutesStore.getCurrentRouteParam 'config'
      ExDbStore = storeProvisioning.createStore(componentId, configId)
      creds = ExDbStore.getEditingCredentials(configId)
      currentConfigId: configId
      isEditing: ExDbStore.isEditingCredentials()
      isSaving: ExDbStore.isSavingCredentials()
      isValid: ExDbStore.hasValidCredentials(creds, {skipProtected: true})

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
            disabled: @state.isSaving or !@state.isValid
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
