React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

ExDbStore = require '../../../exDbStore.coffee'
ExDbActionCreators = require '../../../exDbActionCreators.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

CredentialsForm = React.createFactory(require './CredentialsForm.coffee')

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
    div className: 'container-fluid kbc-main-content',
      TabbedArea defaultActiveKey: 'db', animation: false,
        TabPane eventKey: 'db', tab: 'Database Credentials',
          CredentialsForm
            credentials: if @state.isEditing then @state.editingCredentials else @state.configuration.get 'credentials'
            enabled: @state.isEditing
            onChange: @_handleCredentialsChange
        TabPane eventKey: 'ssl', tab: 'SSL',
          'TODO SSL'
        TabPane eventKey: 'fixedIp', tab: 'Fixed IP',
          'TODO FIXED'
