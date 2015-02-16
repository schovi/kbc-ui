###
  Orchestrations module routing
###

# pages and components
OrchestrationsIndex = require './react/pages/orchestrations-index/OrchestrationsIndex'
OrchestrationDetail = require './react/pages/orchestration-detail/OrchestrationDetail'
OrchestrationJobDetail = require './react/pages/orchestration-job-detail/OrchestrationJobDetail'
OrchestrationTasks = require './react/pages/orchestration-tasks/OrchestrationTasks'

OrchestrationsReloaderButton = require './react/components/OrchestrationsReloaderButton'
NewOrchestrationButton = require './react/components/NewOrchestionButton'
OrchestrationReloaderButton = require './react/components/OrchestrationReloaderButton'
JobReloaderButton = require './react/components/JobReloaderButton'
OrchestrationDetailButtons = require './react/components/OrchestrationDetailButtons'

# stores
OrchestrationsStore = require './stores/OrchestrationsStore'

OrchestrationsActionCreators = require './ActionCreators'

routes =
  name: 'orchestrations'
  title: 'Orchestrations'
  defaultRouteHandler: OrchestrationsIndex
  reloaderHandler: OrchestrationsReloaderButton
  headerButtonsHandler: NewOrchestrationButton
  poll:
    interval: 10
    action: ->
      OrchestrationsActionCreators.loadOrchestrationsForce()
  requireData: ->
    OrchestrationsActionCreators.loadOrchestrations()
  childRoutes: [
    name: 'orchestration'
    path: ':orchestrationId'
    reloaderHandler: OrchestrationReloaderButton
    headerButtonsHandler: OrchestrationDetailButtons
    defaultRouteHandler: OrchestrationDetail
    poll:
      interval: 20
      action: (params) ->
        OrchestrationsActionCreators.loadOrchestrationJobsForce(parseInt(params.orchestrationId))
    requireData: [
        (params) ->
          OrchestrationsActionCreators.loadOrchestration(parseInt(params.orchestrationId))
      ,
        (params) ->
          OrchestrationsActionCreators.loadOrchestrationJobs(parseInt(params.orchestrationId))
    ]
    title: (routerState) ->
      orchestrationId = parseInt(routerState.getIn ['params', 'orchestrationId'])
      OrchestrationsStore.get(orchestrationId).get 'name'

    childRoutes: [
      name: 'orchestrationJob'
      reloaderHandler: JobReloaderButton
      poll:
        interval: 10
        action: (params) ->
          OrchestrationsActionCreators.loadJobForce(parseInt(params.jobId))
      requireData: (params) ->
        OrchestrationsActionCreators.loadJob(parseInt(params.jobId))
      title: (routerState) ->
        'Job ' +  routerState.getIn ['params', 'jobId']
      path: 'jobs/:jobId'
      handler: OrchestrationJobDetail
    ,
      name: 'orchestrationTasks'
      title: 'Tasks'
      path: 'tasks'
      handler: OrchestrationTasks
    ]
  ]

module.exports = routes
