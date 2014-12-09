###
  Orchestrations module routing
###

# pages and components
OrchestrationsIndex = require './pages/OrchestrationsIndex.coffee'
OrchestrationDetail = require './pages/OrchestrationDetail.coffee'
OrchestrationJobDetail = require './pages/OrchestrationJobDetail.coffee'
OrchestrationTasks = require './pages/OrchestrationTasks.coffee'

OrchestrationsReloaderButton = require './components/OrchestrationsReloaderButton.coffee'
NewOrchestrationButton = require './components/NewOrchestionButton.coffee'
OrchestrationReloaderButton = require './components/OrchestrationReloaderButton.coffee'
JobReloaderButton = require './components/JobReloaderButton.coffee'

# stores
OrchestrationsStore = require './stores/OrchestrationsStore.coffee'

OrchestrationsActionCreators = require './ActionCreators.coffee'

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
    poll:
      interval: 10
      action: (params) ->
        OrchestrationsActionCreators.loadOrchestrationJobsForce(params.orchestrationId)
    requireData: [
        (params) ->
          OrchestrationsActionCreators.loadOrchestration(params.orchestrationId)
      ,
        (params) ->
          OrchestrationsActionCreators.loadOrchestrationJobs(params.orchestrationId)
    ]
    title: (routerState) ->
      orchestrationId = routerState.getIn ['params', 'orchestrationId']
      OrchestrationsStore.get(orchestrationId).get 'name'

    defaultRouteHandler: OrchestrationDetail
    childRoutes: [
      name:  'orchestrationJob'
      reloaderHandler: JobReloaderButton
      poll:
        interval: 10
        action: (params) ->
          OrchestrationsActionCreators.loadJobForce(params.jobId)
      requireData: (params) ->
        OrchestrationsActionCreators.loadJob(params.jobId)
      title: (routerState) ->
        'Job ' +  routerState.getIn ['params', 'jobId']
      path: 'jobs/:jobId'
      handler: OrchestrationJobDetail
    ,
      name: 'orchestrationTasks'
      title: 'Tasks'
      path: 'tasks'
      handler: OrchestrationTasks
      reloaderHandler: OrchestrationReloaderButton
    ]
  ]

module.exports = routes
