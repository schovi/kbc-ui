React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

ExDbStore = require '../../../exDbStore.coffee'
ExDbActionCreators = require '../../../exDbActionCreators.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

CredentialsForm = React.createFactory(require './CredentialsForm.coffee')
SSLForm = React.createFactory(require './SSLForm.coffee')
FixedIP = React.createFactory(require './FixedIP.coffee')

TabbedArea = React.createFactory(require('react-bootstrap').TabbedArea)
TabPane = React.createFactory(require('react-bootstrap').TabPane)

{div, form} = React.DOM

module.exports = React.createClass
  displayName: 'ExDbCredentials'
  mixins: [createStoreMixin(ExDbStore)]
  getStateFromStores: ->
    config = RoutesStore.getRouterState().getIn ['params', 'config']
    configuration: ExDbStore.getConfig config
    isEditing: ExDbStore.isEditingCredentials config
    editingCredentials: ExDbStore.getEditingCredentials config

  _handleCredentialsChange: (newCredentials) ->
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
