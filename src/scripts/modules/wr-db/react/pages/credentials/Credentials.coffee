React = require 'react'
_ = require 'underscore'
{fromJS} = require 'immutable'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

{States} = require './StateConstants'
WrDbActions = require '../../../actionCreators'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'


WrDbStore = require '../../../store'
RoutesStore = require '../../../../../stores/RoutesStore'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'

CredentialsForm = require './CredentialsForm'
{div} = React.DOM
Input = React.createFactory(require('react-bootstrap').Input)
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)
{Protected} = require 'kbc-react-components'



{a, h4, form, div, label, p, option} = React.DOM

driver = 'mysql'
componentId = 'wr-db'
isProvisioning = true

module.exports = React.createClass

  displayName: 'WrDbCredentials'

  mixins: [createStoreMixin(InstalledComponentsStore, WrDbStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    credentials = WrDbStore.getCredentials(driver, configId)
    isEditing = !! WrDbStore.getEditingByPath(driver, configId, 'creds')
    editingCredentials = null
    if isEditing
      editingCredentials = WrDbStore.getEditingByPath(driver, configId, 'creds')
    isSaving = !! WrDbStore.getSavingCredentials(driver, configId)

    provisioningCredentials = WrDbStore.getProvisioningCredentials(driver, configId)
    isLoadingProvCredentials = WrDbStore.isLoadingProvCredentials(driver, configId)
    localState = InstalledComponentsStore.getLocalState(componentId, configId)

    localState: localState
    provisioningCredentials: provisioningCredentials
    credentials: credentials
    configId: configId
    editingCredentials: editingCredentials
    isEditing: isEditing
    isSaving: isSaving
    loadingProvisioning: isLoadingProvCredentials

  componentDidMount: ->
    console.log "COMPONENT DIDI MOUNT"
    state = @state.localState.get 'credentialsState'
    # ignore setting state in some cases
    if state in [
      States.SAVING_NEW_CREDS
      States.PREPARING_PROV_WRITE
      States.LOADING_PROV_READ
      States.CREATE_NEW_CREDS]
      return
    if isProvisioning == false
      @_updateLocalState('credentialsState', States.SHOW_STORED_CREDS)
      return

    hasReadCredentials = @state.provisioningCredentials?.get('read')
    if @_hasDbConnection()
      if @_isProvCredentials()
        if hasReadCredentials
          @_updateLocalState('credentialsState', States.SHOW_PROV_READ_CREDS)
        else
          @_runLoadProvReadCredentials()
      else
        @_updateLocalState('credentialsState', States.SHOW_STORED_CREDS)
    else
      @_updateLocalState('credentialsState', States.INIT)

  _runLoadProvReadCredentials: ->
    isReadOnly = true
    @_updateLocalState('credentialsState', States.LOADING_PROV_READ)
    WrDbActions.loadProvisioningCredentials(driver, @state.configId, isReadOnly).then =>
      @_updateLocalState('credentialsState', States.SHOW_PROV_READ_CREDS)

  render: ->
    if isProvisioning
      @renderWithProvisioning()
    else
      @renderNoProvisioning()

  renderNoProvisioning: ->
    credentials = @state.credentials
    state = @state.localState.get 'credentialsState'
    isEditing = false
    if state in [States.SAVING_NEW_CREDS, States.CREATE_NEW_CREDS, States.INIT]
      isEditing = true
      credentials = @state.editingCredentials
    div {className: 'container-fluid kbc-main-content'},
      @_renderCredentialsForm(credentials, isEditing)

  renderWithProvisioning: ->
    credentials = @state.credentials
    state = @state.localState.get 'credentialsState'
    console.log "render credentials", state, @state.localState.toJS()
    div {className: 'container-fluid kbc-main-content'},
      switch state
        when States.INIT
          @_renderInit()
        when States.LOADING_PROV_READ
          div className: 'well', 'Loading provisioning credentials...'
        when States.PREPARING_PROV_WRITE
          div className: 'well', 'Preparing provisioning credentials...'
        when States.SHOW_PROV_READ_CREDS
          @_renderCredentialsForm(@_prepareProvReadCredentials(), false)
        when States.SHOW_STORED_CREDS
          @_renderCredentialsForm(@state.credentials, false)
        when States.CREATE_NEW_CREDS
          @_renderCredentialsForm(@state.editingCredentials, true)
        when States.SAVING_NEW_CREDS
          @_renderCredentialsForm(@state.editingCredentials, true)



  _renderInit: ->
    div className: 'panel panel-default',
      div className: 'panel-heading',
        h4 null, 'Choose which database to use:'
      div className: 'panel-body',
        div className: 'list-group',
          a
            className: 'list-group-item text-center'
            onClick: @_toggleCreateOwnCredentials
          ,
            h4 className: 'list-group-item-heading', 'Own MySQL database'
            p className: 'list-group-item-text', 'User has own mysql database and will provide credenetials'
          a
            className: 'list-group-item text-center'
            onClick: @_toggleCreateProvWriteCredentials

          ,
            h4 className: 'list-group-item-heading', 'Keboola MySQL database'
            p className: 'list-group-item-text', 'Keboola will provide and setup \
            dedicated database and user will be given readonly credentials.'

  _toggleCreateOwnCredentials: ->
    credentials = @state.credentials
    WrDbActions.setEditingData driver, @state.configId, 'creds', credentials
    @_updateLocalState('credentialsState', States.CREATE_NEW_CREDS)


  _toggleCreateProvWriteCredentials: ->
    @_updateLocalState('credentialsState', States.PREPARING_PROV_WRITE)
    isReadOnly = false
    WrDbActions.loadProvisioningCredentials(driver, @state.configId, isReadOnly).then =>
      @_updateLocalState('credentialsState', States.SHOW_PROV_READ_CREDS)



  _prepareProvReadCredentials: ->
    creds = @state.provisioningCredentials?.get('read')
    if not creds
      return null
    return fromJS
      host: creds.get 'hostname'
      database: creds.get 'db'
      port: @state.credentials.get 'port'
      password: creds.get 'password'
      user: creds.get 'user'

  _renderCredentialsForm: (credentials, isEditing) ->
    isSaving = @state.localState.get('credentialsState') == States.SAVING_NEW_CREDS
    React.createElement CredentialsForm,
      isEditing: isEditing
      credentials: credentials
      onChangeFn: @_handleChange
      isSaving: isSaving
      isProvisioning: @_isProvCredentials()

  _isProvCredentials: ->
    result = @state.credentials?.get('host') == 'wr-db.keboola.com'
    result

  _handleChange: (propName, event) ->
    if ['port', 'retries'].indexOf(propName) >= 0
      value = parseInt event.target.value
    else
      value = event.target.value
    creds = @state.credentials.set propName, value
    WrDbActions.setEditingData driver, @state.configId, 'creds', creds
    #@props.onChange(@state.credentials.set propName, value)

  _hasDbConnection: ->
    credentials = @state.credentials.toJS()
    not( _.isEmpty(credentials?.host) or
    _.isEmpty(credentials?.database) or
    _.isEmpty(credentials?.password) or
    _.isEmpty(credentials?.user))

  _updateLocalState: (path, data) ->
    if _.isString path
      path = [path]
    console.log "UPDATE STATE", path, data
    newLocalState = @state.localState.setIn(path, data)
    console.log "new local state", newLocalState.toJS()
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
