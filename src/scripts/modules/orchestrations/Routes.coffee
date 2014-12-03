###
  Orchestrations module routing
###

# pages and components
OrchestrationsIndex = require './pages/OrchestrationsIndex.coffee'
OrchestrationDetail = require './pages/OrchestrationDetail.coffee'
OrchestrationJobDetail = require './pages/OrchestrationJobDetail.coffee'

OrchestrationsReloaderButton = require './components/OrchestrationsReloaderButton.coffee'
NewOrchestrationButton = require './components/NewOrchestionButton.coffee'

# stores
OrchestrationsStore = require './stores/OrchestrationsStore.coffee'

routes =
  name: 'orchestrations'
  title: 'Orchestrations'
  defaultRouteHandler: OrchestrationsIndex
  reloaderHandler: OrchestrationsReloaderButton
  headerButtonsHandler: NewOrchestrationButton
  childRoutes: [
    name: 'orchestration'
    path: ':orchestrationId'
    title: (routerState) ->
      orchestrationId = routerState.getIn ['params', 'orchestrationId']
      orchestration = OrchestrationsStore.get(orchestrationId)
      if orchestration
        "Orchestration #{orchestration.get('name')}"
      else
        "Orchestration #{orchestrationId}"

    defaultRouteHandler: OrchestrationDetail
    childRoutes: [
      name:  'orchestrationJob'
      title: (routerState) ->
        'Job ' +  routerState.getIn ['params', 'jobId']
      path: 'jobs/:jobId'
      handler: OrchestrationJobDetail
    ]
  ]

module.exports = routes
