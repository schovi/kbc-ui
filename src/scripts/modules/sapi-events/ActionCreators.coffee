

dispatcher = require '../../Dispatcher.coffee'
constants = require './Constants.coffee'
orchestrationsApi = require './OrchestrationsApi.coffee'
OrchestrationStore = require './stores/OrchestrationsStore.coffee'
OrchestrationJobsStore = require './stores/OrchestrationJobsStore.coffee'
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
      console.log 'error', err

