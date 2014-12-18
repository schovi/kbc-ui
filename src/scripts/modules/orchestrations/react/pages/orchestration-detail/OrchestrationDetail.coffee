React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

# actions and stores
OrchestrationsActionCreators = require '../../../ActionCreators.coffee'
OrchestrationStore = require '../../../stores/OrchestrationsStore.coffee'
OrchestrationJobsStore = require '../../../stores/OrchestrationJobsStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

# React components
OrchestrationsNav = React.createFactory(require './OrchestrationsNav.coffee')
JobsTable = React.createFactory(require './JobsTable.coffee')
JobsGraph = React.createFactory(require './JobsGraph.coffee')
SearchRow = React.createFactory(require '../../../../../react/common/SearchRow.coffee')
Link = React.createFactory(require('react-router').Link)
TasksSummary = React.createFactory(require './TasksSummary.coffee')
CronRecord = React.createFactory(require '../../components/CronRecord.coffee')

{div, h2, span, strong} = React.DOM

OrchestrationDetail = React.createClass
  displayName: 'OrchestrationDetail'
  mixins: [createStoreMixin(OrchestrationStore, OrchestrationJobsStore)]

  getStateFromStores: ->
    orchestrationId = RoutesStore.getRouterState().getIn ['params', 'orchestrationId']
    return {
      orchestration: OrchestrationStore.get orchestrationId
      tasks: OrchestrationStore.getOrchestrationTasks orchestrationId
      isLoading: OrchestrationStore.getIsOrchestrationLoading orchestrationId
      filteredOrchestrations: OrchestrationStore.getFiltered()
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
          OrchestrationsNav
            orchestrations: @state.filteredOrchestrations
            activeOrchestrationId: @state.orchestration.get 'id'
      div {className: 'col-md-9 kb-orchestrations-main kbc-main-content-with-nav'},
        div className: 'table kbc-table-border-vertical kbc-detail-table',
          div className: 'tr',
            div className: 'td',
              div className: 'row',
                span className: 'col-md-3', 'Schedule '
                strong className: 'col-md-9',
                  CronRecord crontabRecord: @state.orchestration.get('crontabRecord')
              div className: 'row',
                span className: 'col-md-3', 'Assigned Token'
                strong className: 'col-md-9', @state.orchestration.getIn ['token', 'description']
            div className: 'td',
              div className: 'row',
                span className: 'col-md-3', 'Notifications '
                strong className: 'col-md-9', 'TODO'
              div className: 'row',
                span className: 'col-md-3', 'Tasks '
                strong className: 'col-md-9',
                  TasksSummary tasks: @state.tasks
                  Link to: 'orchestrationTasks', params:
                    orchestrationId: @state.orchestration.get('id')
                  ,
                    ' '
                    span className: 'fa fa-edit'
                    ' Configure tasks'
        (JobsGraph(jobs: @state.jobs) if @state.jobs.size >= 2)
        JobsTable(
          jobs: @state.jobs
          jobsLoading: @state.jobsLoading
          onJobsReload: @_handleJobsReload
        )


module.exports = OrchestrationDetail