React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

# actions and stores
OrchestrationsActionCreators = require '../../../ActionCreators'
OrchestrationStore = require '../../../stores/OrchestrationsStore'
OrchestrationJobsStore = require '../../../stores/OrchestrationJobsStore'
RoutesStore = require '../../../../../stores/RoutesStore'

# React components
OrchestrationsNav = React.createFactory(require './OrchestrationsNav')
JobsTable = React.createFactory(require './JobsTable')
JobsGraph = React.createFactory(require './JobsGraph')
SearchRow = React.createFactory(require('../../../../../react/common/SearchRow').default)
Link = React.createFactory(require('react-router').Link)
TasksSummary = React.createFactory(require './TasksSummary')
CronRecord = React.createFactory(require '../../components/CronRecord')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
ScheduleModal = React.createFactory(require('../../modals/Schedule'))

{div, h2, span, strong, br} = React.DOM

OrchestrationDetail = React.createClass
  displayName: 'OrchestrationDetail'
  mixins: [createStoreMixin(OrchestrationStore, OrchestrationJobsStore)]

  getStateFromStores: ->
    orchestrationId = RoutesStore.getCurrentRouteIntParam 'orchestrationId'
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
    div {className: 'container-fluid kbc-main-content'},
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
                  br null
                  ModalTrigger
                    modal: ScheduleModal
                      crontabRecord: @state.orchestration.get 'crontabRecord'
                      orchestrationId: @state.orchestration.get 'id'
                  ,
                    span className: 'btn btn-link',
                      span className: 'fa fa-edit'
                      ' Edit schedule'
              div className: 'row',
                span className: 'col-md-3', 'Assigned Token'
                strong className: 'col-md-9', @state.orchestration.getIn ['token', 'description']
            div className: 'td',
              div className: 'row',
                span className: 'col-md-3', 'Notifications '
                strong className: 'col-md-9',
                  if @state.orchestration.get('notifications').count()
                    span className: 'badge',
                      @state.orchestration.get('notifications').count()
                  else
                    span null,
                      'No notifications set yet'
                  br null
                  Link
                    to: 'orchestrationNotifications'
                    params:
                      orchestrationId: @state.orchestration.get('id')
                  ,
                    ' '
                    span className: 'fa fa-edit'
                    ' Configure Notifications'
              div className: 'row',
                span className: 'col-md-3', 'Tasks '
                strong className: 'col-md-9',
                  TasksSummary tasks: @state.tasks
                  br null
                  Link to: 'orchestrationTasks', params:
                    orchestrationId: @state.orchestration.get('id')
                  ,
                    ' '
                    span className: 'fa fa-edit'
                    ' Configure Tasks'
        (JobsGraph(jobs: @state.jobs) if @state.jobs.size >= 2)
        JobsTable(
          jobs: @state.jobs
          jobsLoading: @state.jobsLoading
          onJobsReload: @_handleJobsReload
        )


module.exports = OrchestrationDetail
