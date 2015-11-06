React = require 'react'
{Map} = require 'immutable'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

# actions and stores
OrchestrationsActionCreators = require '../../../ActionCreators'
OrchestrationStore = require '../../../stores/OrchestrationsStore'
RoutesStore = require '../../../../../stores/RoutesStore'

# React components
OrchestrationsNav = React.createFactory(require './../orchestration-detail/OrchestrationsNav')
SearchRow = React.createFactory(require('../../../../../react/common/SearchRow').default)
Notifications = require './Notifications'

{div, button} = React.DOM

module.exports = React.createClass
  displayName: 'OrchestrationNofitications'
  mixins: [createStoreMixin(OrchestrationStore)]


  getInitialState: ->
    inputs: Map
      error: ''
      warning: ''
      processing: ''
      waiting: ''


  getStateFromStores: ->
    orchestrationId = RoutesStore.getCurrentRouteIntParam 'orchestrationId'
    orchestration = OrchestrationStore.get orchestrationId
    isEditing = OrchestrationStore.isEditing(orchestrationId, 'notifications')

    if isEditing
      notifications = OrchestrationStore.getEditingValue orchestrationId, 'notifications'
    else
      notifications = orchestration.get 'notifications'
    return {
      orchestration: orchestration
      notifications: notifications
      filter: OrchestrationStore.getFilter()
      isEditing: isEditing
      isSaving: OrchestrationStore.isSaving(orchestrationId, 'notifications')
      filteredOrchestrations: OrchestrationStore.getFiltered()
    }

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  _handleFilterChange: (query) ->
    OrchestrationsActionCreators.setOrchestrationsFilter(query)

  _handleNotificationsChange: (newNotifications) ->
    OrchestrationsActionCreators.updateOrchestrationNotificationsEdit @state.orchestration.get('id'),
      newNotifications

  _handleInputChange: (channelName, newValue) ->
    @setState
      inputs: @state.inputs.set channelName, newValue

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      div {className: 'col-md-3 kb-orchestrations-sidebar kbc-main-nav'},
        div {className: 'kbc-container'},
          SearchRow(onChange: @_handleFilterChange, query: @state.filter)
          OrchestrationsNav
            orchestrations: @state.filteredOrchestrations
            activeOrchestrationId: @state.orchestration.get 'id'
      div {className: 'col-md-9 kb-orchestrations-main kbc-main-content-with-nav'},
        React.createElement Notifications,
          notifications: @state.notifications
          inputs: @state.inputs
          isEditing: @state.isEditing
          onNotificationsChange: @_handleNotificationsChange
          onInputChange: @_handleInputChange
