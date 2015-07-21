React = require 'react'
_ = require 'underscore'
{fromJS} = require 'immutable'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

WrDbActions = require '../../../actionCreators'

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

module.exports = React.createClass

  displayName: 'WrDbCredentials'

  mixins: [createStoreMixin(InstalledComponentsStore, WrDbStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    credentials = WrDbStore.getCredentials(driver, configId)
    isEditing = !! WrDbStore.getEditingByPath(driver, configId, 'creds')
    if isEditing
      credentials = WrDbStore.getEditingByPath(driver, configId, 'creds')
    isSaving = !! WrDbStore.getSavingCredentials(driver, configId)

    provisioningCredentials = WrDbStore.getProvisioningCredentials(driver, configId)
    isLoadingProvCredentials = WrDbStore.isLoadingProvCredentials(driver, configId)

    provisioningCredentials: provisioningCredentials
    credentials: credentials
    configId: configId
    isEditing: isEditing
    isSaving: isSaving
    loadingProvisioningCredentials: isLoadingProvCredentials

  componentDidMount: ->
    #if current credentials are provisioning creds then we trigger
    #readonly load of credentials
    creds = @state.credentials.toJS()
    if @_hasDbConnection(creds)
      if @_isProvCredentials()
        if not @state.provisioningCredentials?.get('read')
          isReadOnly = true
          WrDbActions.loadProvisioningCredentials(driver, @state.configId, isReadOnly)


  render: ->
    credentials = @state.credentials
    if @_isProvCredentials()
      credentials = @_prepareProvReadCredentials()
    div {className: 'container-fluid kbc-main-content'},
      if @_hasDbConnection(@state.credentials?.toJS())
        if @state.loadingProvisioningCredentials
          div className: 'well', 'Loading credentials...'
        else
          @_renderCredentialsForm(credentials) if credentials
      else
        @_renderInit()

  _renderInit: ->
    div className: 'panel panel-default',
      div className: 'panel-heading',
        h4 null, 'Choose which database to use:'
      div className: 'panel-body',
        div className: 'list-group',
          a
            className: 'list-group-item text-center'
            onClick: ->
              console.log "clickeeed"
          ,
            h4 className: 'list-group-item-heading', 'Own MySQL database'
            p className: 'list-group-item-text', 'User has own mysql database and will provide credenetials'
          a
            className: 'list-group-item text-center'
            onClick: =>
              isReadOnly = false
              WrDbActions.loadProvisioningCredentials(driver, @state.configId, isReadOnly)
          ,
            h4 className: 'list-group-item-heading', 'Keboola MySQL database'
            p className: 'list-group-item-text', 'Keboola will provide and setup \
            dedicated database and user will be given readonly credentials.'




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

  _renderCredentialsForm: (credentials) ->
    React.createElement CredentialsForm,
      isEditing: @state.isEditing
      credentials: credentials
      onChangeFn: @_handleChange.bind @

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

  _hasDbConnection: (credentials) ->
    not( _.isEmpty(credentials?.host) or
    _.isEmpty(credentials?.database) or
    _.isEmpty(credentials?.password) or
    _.isEmpty(credentials?.user))
