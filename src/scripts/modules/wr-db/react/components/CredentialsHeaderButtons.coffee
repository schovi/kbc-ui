React = require 'react'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
WrDbStore = require '../../store'
RoutesStore = require '../../../../stores/RoutesStore'
ActionCreators = require '../../actionCreators'
{Navigation} = require 'react-router'

Loader = React.createFactory(require('kbc-react-components').Loader)
driver = 'mysql'


{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'CredentialsHeaderButtons'
  mixins: [createStoreMixin(WrDbStore), Navigation]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    currentCredentials = WrDbStore.getCredentials driver, configId

    currentCredentials: currentCredentials
    currentConfigId: configId
    isEditing: !! WrDbStore.getEditingByPath(driver, configId, 'creds')
    isSaving: !! WrDbStore.getSavingCredentials(driver, configId)

  _handleEditStart: ->
    creds = @state.currentCredentials
    ActionCreators.setEditingData driver, @state.currentConfigId, 'creds', creds

  _handleCancel: ->
    ActionCreators.setEditingData driver, @state.currentConfigId, 'creds', null


  _handleCreate: ->
    editingCredentials =  WrDbStore.getEditingByPath(driver, @state.currentConfigId, 'creds')
    ActionCreators
    .saveCredentials(driver, @state.currentConfigId, editingCredentials).then =>
      @_handleCancel()

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
