React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

# actions and stores
OrchestrationsActionCreators = require '../../../ActionCreators'
OrchestrationStore = require '../../../stores/OrchestrationsStore'
RoutesStore = require '../../../../../stores/RoutesStore'

# React components
OrchestrationsNav = React.createFactory(require './../orchestration-detail/OrchestrationsNav')
SearchRow = React.createFactory(require '../../../../../react/common/SearchRow')

{div, button} = React.DOM

module.exports = React.createClass
  displayName: 'OrchestrationNofitications'
  mixins: [createStoreMixin(OrchestrationStore)]

  getStateFromStores: ->
    orchestrationId = RoutesStore.getCurrentRouteIntParam 'orchestrationId'
    isEditing = OrchestrationStore.isEditing(orchestrationId, 'notifications')

    return {
      orchestration: OrchestrationStore.get orchestrationId
      filter: OrchestrationStore.getFilter()
      isEditing: isEditing
      isSaving: OrchestrationStore.isSaving(orchestrationId, 'notifications')
      filteredOrchestrations: OrchestrationStore.getFiltered()
    }

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  _handleFilterChange: (query) ->
    OrchestrationsActionCreators.setOrchestrationsFilter(query)

  _handleSave: ->
    console.log 'todo save'

  _handleReset: ->
    console.log 'todo reset'

  _startEditing: ->
    console.log 'todo start'

  _handleTasksChange: (newTasks) ->
    console.log 'todo change'

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      div {className: 'col-md-3 kb-orchestrations-sidebar kbc-main-nav'},
        div {className: 'kbc-container'},
          SearchRow(onChange: @_handleFilterChange, query: @state.filter)
          OrchestrationsNav
            orchestrations: @state.filteredOrchestrations
            activeOrchestrationId: @state.orchestration.get 'id'
      div {className: 'col-md-9 kb-orchestrations-main kbc-main-content-with-nav'},
        'TODO'
