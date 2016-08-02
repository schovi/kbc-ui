

dispatcher = require '../../Dispatcher'
constants = require './Constants'
orchestrationsApi = require './OrchestrationsApi'
OrchestrationStore = require './stores/OrchestrationsStore'
OrchestrationJobsStore = require './stores/OrchestrationJobsStore'
Promise = require 'bluebird'

module.exports =

  loadEventsForce: (params) ->
    actions = @

    # trigger load initialized
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATIONS_LOAD
    )

    # init load
    orchestrationsApi
    .getOrchestrations()
    .then((orchestrations) ->
      # load success
      actions.receiveAllOrchestrations(orchestrations)
    )
    .catch (err) ->
      throw err

