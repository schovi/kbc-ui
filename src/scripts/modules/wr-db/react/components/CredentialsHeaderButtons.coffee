React = require 'react'
_ = require 'underscore'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'
WrDbStore = require '../../store'
RoutesStore = require '../../../../stores/RoutesStore'
ActionCreators = require '../../actionCreators'
{Navigation} = require 'react-router'
InstalledComponentsStore = require '../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../components/InstalledComponentsActionCreators'
Loader = React.createFactory(require('kbc-react-components').Loader)
{States} = require '../pages/credentials/StateConstants'


driver = 'mysql'
componentId = 'wr-db'

isProvisioning = false

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'CredentialsHeaderButtons'
  mixins: [createStoreMixin(WrDbStore, InstalledComponentsStore), Navigation]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    currentCredentials = WrDbStore.getCredentials driver, configId
    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    credsState = localState.get 'credentialsState'

    currentCredentials: currentCredentials
    currentConfigId: configId
    isEditing: !! WrDbStore.getEditingByPath(driver, configId, 'creds')
    isSaving: credsState == States.SAVING_NEW_CREDS
    localState: localState

  _handleResetStart: ->
    if isProvisioning
      @_updateLocalState('credentialsState', States.INIT)
    else
      creds = @state.currentCredentials
      #ActionCreators.resetCredentials driver, @state.currentConfigId
      ActionCreators.setEditingData driver, @state.currentConfigId, 'creds', creds
      @_updateLocalState('credentialsState', States.CREATE_NEW_CREDS)

  _handleCancel: ->
    if isProvisioning
      @_updateLocalState('credentialsState', States.INIT)
    else
      ActionCreators.setEditingData driver, @state.currentConfigId, 'creds', null
      @_updateLocalState('credentialsState', States.SHOW_STORED_CREDS)


  _handleCreate: ->
    @_updateLocalState('credentialsState', States.SAVING_NEW_CREDS)
    editingCredentials =  WrDbStore.getEditingByPath(driver, @state.currentConfigId, 'creds')
    ActionCreators
    .saveCredentials(driver, @state.currentConfigId, editingCredentials).then =>
      @_updateLocalState('credentialsState', States.SHOW_STORED_CREDS)


  render: ->
    state = @state.localState.get 'credentialsState'
    buttonText = ' Edit'
    if isProvisioning
      buttonText = ' Reset Credentials'

    if state in [States.SHOW_PROV_READ_CREDS, States.SHOW_STORED_CREDS]
      return React.DOM.div null,
        button
          className: 'btn btn-success'
          disabled: @state.isSaving
          onClick: @_handleResetStart
        ,
          span className: 'fa fa-edit'
          buttonText

    if state in [States.CREATE_NEW_CREDS, States.SAVING_NEW_CREDS]
      return React.DOM.div className: 'kbc-buttons',
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
      return null

  _updateLocalState: (path, data) ->
    if _.isString path
      path = [path]
    console.log "UPDATE STATE", path, data
    newLocalState = @state.localState.setIn(path, data)
    console.log "new local state", newLocalState.toJS()
    InstalledComponentsActions.updateLocalState(componentId, @state.currentConfigId, newLocalState)
