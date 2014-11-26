React = require 'react'
Router = require 'react-router'

# actions and stores
OrchestrationsActionCreators = require '../../actions/OrchestrationsActionCreators.coffee'
OrchestrationStore = require '../../stores/OrchestrationStore.coffee'
OrchestrationJobsStore = require '../../stores/OrchestrationJobsStore.coffee'

# components
JobsNav = React.createFactory(require './job-detail/JobsNav.coffee')
JobTasks = React.createFactory(require './job-detail/JobTasks.coffee')


{div} = React.DOM

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
      JobTasks(tasks: @props.job.results.tasks)
)


OrchestrationJobDetail = React.createClass
  displayName: 'OrchestrationJobDetail'
  mixins: [Router.State]

  _getJobId: ->
    # using getParams method provided by Router.State mixin
    parseInt(@getParams().jobId)

  _getOrchestrationId: ->
    parseInt(@getParams().orchestrationId)

  _getStateFromStores: ->
    orchestrationId = @_getOrchestrationId()
    return {
      job: OrchestrationJobsStore.getJob @_getJobId()
      isLoading: OrchestrationJobsStore.isJobLoading @_getJobId()
      jobs: OrchestrationJobsStore.getOrchestrationJobs orchestrationId
      jobsLoading: OrchestrationJobsStore.isLoading orchestrationId
    }

  getInitialState: ->
    @_getStateFromStores()

  componentDidMount: ->
    OrchestrationStore.addChangeListener(@_onChange)
    OrchestrationJobsStore.addChangeListener(@_onChange)
    OrchestrationsActionCreators.loadOrchestrationJobs(@_getOrchestrationId())
    OrchestrationsActionCreators.loadJob(@_getJobId())

  componentWillReceiveProps: ->
    @setState(@_getStateFromStores())
    OrchestrationsActionCreators.loadOrchestrationJobs(@_getOrchestrationId())
    OrchestrationsActionCreators.loadJob(@_getJobId())

  componentWillUnmount: ->
    OrchestrationStore.removeChangeListener(@_onChange)
    OrchestrationJobsStore.removeChangeListener(@_onChange)

  _onChange: ->
    @setState(@_getStateFromStores())


  render: ->
    if @state.job
      body = JobDetailBody(job: @state.job.toJS())
    else if !@state.isLoading
      body = JobNotFound(jobId: @getParams().jobId)
    else
      body = 'Loading ...'

    div {className: 'container-fluid'},
      div {className: 'row'},
        div {className: 'col-md-3 kb-orchestrations-sidebar'},
          JobsNav jobs: @state.jobs.toJS(), jobsLoading: @state.jobsLoading
        div {className: 'col-md-9 kb-orchestrations-main'},
          div {},
            body


module.exports = OrchestrationJobDetail