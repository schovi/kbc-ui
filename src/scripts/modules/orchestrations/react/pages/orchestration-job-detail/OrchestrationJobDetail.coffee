React = require 'react'
List = require('immutable').List
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

# actions and stores
OrchestrationsActionCreators = require '../../../ActionCreators.coffee'
OrchestrationStore = require '../../../stores/OrchestrationsStore.coffee'
OrchestrationJobsStore = require '../../../stores/OrchestrationJobsStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

# components
JobsNav = React.createFactory(require './JobsNav.coffee')
JobOverview = React.createFactory(require './Overview.coffee')

TabbedArea = React.createFactory(require('react-bootstrap').TabbedArea)
TabPane = React.createFactory(require('react-bootstrap').TabPane)

{div} = React.DOM

OrchestrationJobDetail = React.createClass
  displayName: 'OrchestrationJobDetail'
  mixins: [createStoreMixin(OrchestrationStore, OrchestrationJobsStore)]

  getStateFromStores: ->
    orchestrationId = RoutesStore.getRouterState().getIn ['params', 'orchestrationId']
    jobId = RoutesStore.getRouterState().getIn ['params', 'jobId']
    return {
      job: OrchestrationJobsStore.getJob jobId
      isLoading: OrchestrationJobsStore.isJobLoading jobId
      jobs: OrchestrationJobsStore.getOrchestrationJobs orchestrationId
      jobsLoading: OrchestrationJobsStore.isLoading orchestrationId
    }

  componentDidMount: ->
    OrchestrationsActionCreators.loadOrchestrationJobs(@state.job.get 'orchestrationId')

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())
    OrchestrationsActionCreators.loadOrchestrationJobs(@state.job.get 'orchestrationId')

  render: ->
    div {className: 'container-fluid'},
      div {className: 'col-md-3 kb-orchestrations-sidebar kbc-main-nav'},
        div {className: 'kbc-container'},
          JobsNav jobs: @state.jobs, jobsLoading: @state.jobsLoading
      div {className: 'col-md-9 kb-orchestrations-main kbc-main-content-with-nav'},
        div {},
          TabbedArea defaultActiveKey: 'overview', animation: false,
            TabPane eventKey: 'overview', tab: 'Overview',
              JobOverview(job: @state.job)
            TabPane eventKey: 'log', tab: 'Log',
              'Todo'


module.exports = OrchestrationJobDetail