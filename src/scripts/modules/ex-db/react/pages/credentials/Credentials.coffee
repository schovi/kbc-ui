React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

ExDbStore = require '../../../exDbStore'
ExDbActionCreators = require '../../../exDbActionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'

CredentialsForm = React.createFactory(require './CredentialsForm')
SSLForm = React.createFactory(require './SSLForm')
FixedIP = React.createFactory(require './FixedIP')

TabbedArea = React.createFactory(require('react-bootstrap').TabbedArea)
TabPane = React.createFactory(require('react-bootstrap').TabPane)

{div, form} = React.DOM

module.exports = React.createClass
  displayName: 'ExDbCredentials'
  mixins: [createStoreMixin(ExDbStore)]
  getStateFromStores: ->
    config = RoutesStore.getCurrentRouteParam 'config'
    configuration: ExDbStore.getConfig config
    isEditing: ExDbStore.isEditingCredentials config
    editingCredentials: ExDbStore.getEditingCredentials config

  _handleCredentialsChange: (newCredentials) ->
    console.log 'new creds', newCredentials.toJS()
    ExDbActionCreators.updateEditingCredentials @state.configuration.get('id'), newCredentials

  render: ->
    if @state.isEditing
      credentials = @state.editingCredentials
    else
      credentials = @state.configuration.get 'credentials'

    div className: 'container-fluid kbc-main-content',
      TabbedArea defaultActiveKey: 'db', animation: false,
        TabPane eventKey: 'db', tab: 'Database Credentials',
          CredentialsForm
            credentials: credentials
            enabled: @state.isEditing
            onChange: @_handleCredentialsChange
        TabPane eventKey: 'ssl', tab: 'SSL',
          SSLForm
            credentials: credentials
            enabled: @state.isEditing
            onChange: @_handleCredentialsChange
        TabPane eventKey: 'fixedIp', tab: 'Fixed IP',
          FixedIP
            credentials: credentials
