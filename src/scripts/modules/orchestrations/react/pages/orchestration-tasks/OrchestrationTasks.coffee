React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

# actions and stores
OrchestrationsActionCreators = require '../../../ActionCreators'
OrchestrationStore = require '../../../stores/OrchestrationsStore'
ComponentsStore = require '../../../../components/stores/ComponentsStore'
RoutesStore = require '../../../../../stores/RoutesStore'

# React components
OrchestrationsNav = React.createFactory(require './../orchestration-detail/OrchestrationsNav')
SearchRow = React.createFactory(require '../../../../../react/common/SearchRow')
TasksTable = React.createFactory(require './TasksTable')
TasksEditor = React.createFactory(require './TasksEditor')

{div, button} = React.DOM

OrchestrationTasks = React.createClass
  displayName: 'OrchestrationTasks'
  mixins: [createStoreMixin(OrchestrationStore, ComponentsStore)]

  getStateFromStores: ->
    orchestrationId = RoutesStore.getCurrentRouteIntParam 'orchestrationId'
    return {
      orchestration: OrchestrationStore.get orchestrationId
      tasks: OrchestrationStore.getOrchestrationTasks orchestrationId
      components: ComponentsStore.getAll()
      filter: OrchestrationStore.getFilter()
      isEditing: false
      filteredOrchestrations: OrchestrationStore.getFiltered()
    }

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  _handleFilterChange: (query) ->
    OrchestrationsActionCreators.setOrchestrationsFilter(query)

  _handleTasksSave: (tasks) ->
    @setState(
      isEditing: false
    )
    OrchestrationsActionCreators.saveOrchestrationTasks(
      @state.orchestration.get('id')
      tasks.toJS()
    )

  _handleReset: ->
    @setState(
      isEditing: false
    )

  _startEditing: ->
    @setState
      isEditing: true

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      div {className: 'col-md-3 kb-orchestrations-sidebar kbc-main-nav'},
        div {className: 'kbc-container'},
          SearchRow(onChange: @_handleFilterChange, query: @state.filter)
          OrchestrationsNav
            orchestrations: @state.filteredOrchestrations
            activeOrchestrationId: @state.orchestration.get 'id'
      div {className: 'col-md-9 kb-orchestrations-main kbc-main-content-with-nav'},
        if @state.isEditing
          div null,
            TasksEditor
              tasks: @state.tasks
              components: @state.components
              onSave: @_handleTasksSave
              onCancel: @_handleReset
        else
          div null,
            TasksTable
              tasks: @state.tasks
              components: @state.components
            button onClick: @_startEditing, className: 'btn btn-primary',
              'Edit tasks'


module.exports = OrchestrationTasks