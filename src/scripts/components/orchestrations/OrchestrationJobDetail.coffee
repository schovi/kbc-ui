React = require 'react'
Router = require 'react-router'

createStoreMixin = require '../../mixins/createStoreMixin.coffee'

# actions and stores
OrchestrationsActionCreators = require '../../actions/OrchestrationsActionCreators.coffee'
OrchestrationStore = require '../../stores/OrchestrationStore.coffee'
OrchestrationJobsStore = require '../../stores/OrchestrationJobsStore.coffee'

# components
JobsNav = React.createFactory(require './job-detail/JobsNav.coffee')
JobTasks = React.createFactory(require './job-detail/JobTasks.coffee')
Duration = React.createFactory(require '../common/Duration.coffee')

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
      @props.job.id,
      h2 null,
        'Tasks',
        ' ',
        @_renderTotalDurationInHeader(),
      JobTasks(tasks: @props.job.results.tasks)

  _renderTotalDurationInHeader: ->
    return '' if !@props.job.startTime
    small null,
      'Total Duration ',
      Duration startTime: @props.job.startTime, endTime: @props.job.endTime
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
    OrchestrationsActionCreators.loadJob(@_getJobId())

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())
    OrchestrationsActionCreators.loadOrchestrationJobs(@_getOrchestrationId())
    OrchestrationsActionCreators.loadJob(@_getJobId())

  render: ->

    if @state.job
      body = div null,
        TabbedArea defaultActiveKey: 'overview', animation: false,
          TabPane eventKey: 'overview', tab: 'Overview', JobDetailBody(job: @state.job.toJS())
          TabPane eventKey: 'log', tab: 'Log', 'Todo'

    else if !@state.isLoading
      body = JobNotFound(jobId: @getParams().jobId)

    else
      body = 'Loading ...'

    div {className: 'container-fluid'},
      div {className: 'col-md-3 kb-orchestrations-sidebar'},
        JobsNav jobs: @state.jobs.toJS(), jobsLoading: @state.jobsLoading
      div {className: 'col-md-9 kb-orchestrations-main'},
        div {},
          body


module.exports = OrchestrationJobDetail