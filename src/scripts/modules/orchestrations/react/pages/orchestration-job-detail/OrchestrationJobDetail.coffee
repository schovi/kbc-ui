React = require 'react'
List = require('immutable').List
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

# actions and stores
OrchestrationsActionCreators = require '../../../ActionCreators'
OrchestrationStore = require '../../../stores/OrchestrationsStore'
OrchestrationJobsStore = require '../../../stores/OrchestrationJobsStore'
RoutesStore = require '../../../../../stores/RoutesStore'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'

mergeTasksWithConfigurations = require('../../../mergeTasksWithConfigruations').default

# components
JobsNav = React.createFactory(require './JobsNav')
JobOverview = React.createFactory(require './Overview')
Events = React.createFactory(require '../../../../sapi-events/react/Events')

TabbedArea = React.createFactory(require('react-bootstrap').TabbedArea)
TabPane = React.createFactory(require('react-bootstrap').TabPane)

{div} = React.DOM

OrchestrationJobDetail = React.createClass
  displayName: 'OrchestrationJobDetail'
  mixins: [createStoreMixin(OrchestrationStore, OrchestrationJobsStore, InstalledComponentsStore)]

  getStateFromStores: ->
    orchestrationId = RoutesStore.getCurrentRouteIntParam 'orchestrationId'
    jobId = RoutesStore.getCurrentRouteIntParam 'jobId'
    job = OrchestrationJobsStore.getJob(jobId)
    if job.hasIn ['results', 'tasks']
      merged = mergeTasksWithConfigurations(job.getIn(['results', 'tasks'], List())
      , InstalledComponentsStore.getAll(), true)

      job = job.setIn(['results', 'tasks'], merged)

    return {
      orchestrationId: orchestrationId
      job: job
      isLoading: OrchestrationJobsStore.isJobLoading jobId
      jobs: OrchestrationJobsStore.getOrchestrationJobs orchestrationId
      jobsLoading: OrchestrationJobsStore.isLoading orchestrationId
      openedTab: if RoutesStore.getRouterState().hasIn(['query', 'eventId']) then 'log' else 'overview'
    }

  componentDidMount: ->
    OrchestrationsActionCreators.loadOrchestrationJobs(@state.job.get 'orchestrationId')

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())
    OrchestrationsActionCreators.loadOrchestrationJobs(@state.job.get 'orchestrationId')

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      div {className: 'col-md-3 kb-orchestrations-sidebar kbc-main-nav'},
        div {className: 'kbc-container'},
          JobsNav
            jobs: @state.jobs
            jobsLoading: @state.jobsLoading
            activeJobId: @state.job.get 'id'
      div {className: 'col-md-9 kb-orchestrations-main kbc-main-content-with-nav'},
        div {},
          TabbedArea defaultActiveKey: @state.openedTab, animation: false,
            TabPane eventKey: 'overview', tab: 'Overview',
              JobOverview(job: @state.job)
            TabPane eventKey: 'log', tab: 'Log',
              Events
                link:
                  to: 'orchestrationJob'
                  params:
                    orchestrationId: @state.orchestrationId
                    jobId: @state.job.get('id')
                params:
                  runId: @state.job.get('runId')
                autoReload: @state.job.get('status') == 'waiting' ||  @state.job.get('status') == 'processing'



module.exports = OrchestrationJobDetail
