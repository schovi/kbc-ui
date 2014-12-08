React = require 'react'
Router = require 'react-router'

createStoreMixin = require '../../../mixins/createStoreMixin.coffee'

# actions and stores
OrchestrationsActionCreators = require '../ActionCreators.coffee'
OrchestrationStore = require '../stores/OrchestrationsStore.coffee'
OrchestrationJobsStore = require '../stores/OrchestrationJobsStore.coffee'
RoutesStore = require '../../../stores/RoutesStore.coffee'

# React components
OrchestrationsNav = React.createFactory(require './orchestration-detail/OrchestrationsNav.coffee')
JobsTable = React.createFactory(require './orchestration-detail/JobsTable.coffee')
SearchRow = React.createFactory(require '../../../components/common/SearchRow.coffee')

{div, h2} = React.DOM

OrchestrationDetail = React.createClass
  displayName: 'OrchestrationDetail'
  mixins: [createStoreMixin(OrchestrationStore, OrchestrationJobsStore)]

  getStateFromStores: ->
    orchestrationId = RoutesStore.getRouterState().getIn ['params', 'orchestrationId']
    return {
      orchestration: OrchestrationStore.get orchestrationId
      tasks: OrchestrationStore.getOrchestrationTasks orchestrationId
      isLoading: OrchestrationStore.getIsOrchestrationLoading orchestrationId
      filter: OrchestrationStore.getFilter()
      jobs: OrchestrationJobsStore.getOrchestrationJobs orchestrationId
      jobsLoading: OrchestrationJobsStore.isLoading orchestrationId
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
        div {className: 'row kbc-header'},
          div {className: 'kbc-title'},
            h2 null,
              'Orchestration ' + @state.orchestration.get('name')
          div {className: 'kbc-buttons'},
            Router.Link to: 'orchestrationTasks', params:
              orchestrationId: @state.orchestration.get('id')
            , "Tasks (#{@state.tasks.size})"
        JobsTable(
          jobs: @state.jobs
          jobsLoading: @state.jobsLoading
          onJobsReload: @_handleJobsReload
        )


module.exports = OrchestrationDetail