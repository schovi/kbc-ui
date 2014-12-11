React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

# actions and stores
OrchestrationsActionCreators = require '../../../ActionCreators.coffee'
OrchestrationStore = require '../../../stores/OrchestrationsStore.coffee'
ComponentsStore = require '../../../../components/stores/ComponentsStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

# React components
OrchestrationsNav = React.createFactory(require './../orchestration-detail/OrchestrationsNav.coffee')
SearchRow = React.createFactory(require '../../../../../react/common/SearchRow.coffee')
TasksTable = React.createFactory(require './TasksTable.coffee')

{div, h2} = React.DOM

OrchestrationTasks = React.createClass
  displayName: 'OrchestrationTasks'
  mixins: [createStoreMixin(OrchestrationStore, ComponentsStore)]

  getStateFromStores: ->
    orchestrationId = RoutesStore.getRouterState().getIn ['params', 'orchestrationId']
    return {
      orchestration: OrchestrationStore.get orchestrationId
      tasks: OrchestrationStore.getOrchestrationTasks orchestrationId
      components: ComponentsStore.getAll()
      isLoading: OrchestrationStore.getIsOrchestrationLoading orchestrationId
      filter: OrchestrationStore.getFilter()
    }

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  _handleFilterChange: (query) ->
    OrchestrationsActionCreators.setOrchestrationsFilter(query)

  _handleJobsReload: ->
    OrchestrationsActionCreators.loadOrchestrationJobsForce(@state.orchestration.get 'id')

  render: ->
    div {className: 'container-fluid'},
      div {className: 'col-md-3 kb-orchestrations-sidebar kbc-main-nav'},
        div {className: 'kbc-container'},
          SearchRow(onChange: @_handleFilterChange, query: @state.filter)
          OrchestrationsNav()
      div {className: 'col-md-9 kb-orchestrations-main kbc-main-content-with-nav'},
        TasksTable(tasks: @state.tasks, components: @state.components)


module.exports = OrchestrationTasks