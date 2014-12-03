React = require 'react'
Router = require 'react-router'

createStoreMixin = require '../../../mixins/createStoreMixin.coffee'

# actions and stores
OrchestrationsActionCreators = require '../ActionCreators.coffee'
OrchestrationStore = require '../stores/OrchestrationsStore.coffee'
OrchestrationJobsStore = require '../stores/OrchestrationJobsStore.coffee'

# components
JobsNav = React.createFactory(require './orchestration-job-detail/JobsNav.coffee')
JobTasks = React.createFactory(require './orchestration-job-detail/JobTasks.coffee')
Duration = React.createFactory(require '../../../components/common/Duration.coffee')

TabbedArea = React.createFactory(require('react-bootstrap').TabbedArea)
TabPane = React.createFactory(require('react-bootstrap').TabPane)

{div, h2, small} = React.DOM

JobNotFound = React.createFactory(React.createClass
  displayName: 'JobNotFound'
  render: ->
    div null, "Job #{@props.jobId} not found."
)

JobDetailBody = React.createFactory(React.createClass
  displayName: 'JobDetailBody'
  render: ->
    div null,
      @props.job.get('id'),
      h2 null,
        'Tasks',
        ' ',
        @_renderTotalDurationInHeader(),
      JobTasks(tasks: @props.job.getIn ['results', 'tasks'])

  _renderTotalDurationInHeader: ->
    return '' if !@props.job.get('startTime')
    small null,
      'Total Duration ',
      Duration
        startTime: @props.job.get('startTime')
        endTime: @props.job.get('endTime')
)

OrchestrationJobDetail = React.createClass
  displayName: 'OrchestrationJobDetail'
  mixins: [Router.State, createStoreMixin(OrchestrationStore, OrchestrationJobsStore)]

  getStateFromStores: ->
    orchestrationId = @_getOrchestrationId()
    return {
      job: OrchestrationJobsStore.getJob @_getJobId()
      isLoading: OrchestrationJobsStore.isJobLoading @_getJobId()
      jobs: OrchestrationJobsStore.getOrchestrationJobs orchestrationId
      jobsLoading: OrchestrationJobsStore.isLoading orchestrationId
    }

  _getJobId: ->
    # using getParams method provided by Router.State mixin
    parseInt(@getParams().jobId)

  _getOrchestrationId: ->
    parseInt(@getParams().orchestrationId)

  componentDidMount: ->
    OrchestrationsActionCreators.loadOrchestrationJobs(@_getOrchestrationId())

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())
    OrchestrationsActionCreators.loadOrchestrationJobs(@_getOrchestrationId())

  render: ->

    if @state.job
      body = div null,
        TabbedArea defaultActiveKey: 'overview', animation: false,
          TabPane eventKey: 'overview', tab: 'Overview', JobDetailBody(job: @state.job)
          TabPane eventKey: 'log', tab: 'Log', 'Todo'

    else if !@state.isLoading
      body = JobNotFound(jobId: @getParams().jobId)

    else
      body = 'Loading ...'

    div {className: 'container-fluid'},
      div {className: 'col-md-3 kb-orchestrations-sidebar'},
        JobsNav jobs: @state.jobs, jobsLoading: @state.jobsLoading
      div {className: 'col-md-9 kb-orchestrations-main'},
        div {},
          body


module.exports = OrchestrationJobDetail