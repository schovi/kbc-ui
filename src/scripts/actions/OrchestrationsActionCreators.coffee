

dispatcher = require '../dispatcher/KbcDispatcher.coffee'
constants = require '../constants/KbcConstants.coffee'
orchestrationsApi = require '../apis/orchestrationsApi.coffee'
OrchestrationStore = require '../stores/OrchestrationStore.coffee'


module.exports =

  loadOrchestrations: ->
    # don't load if already loaded
    return if OrchestrationStore.getIsLoaded()

    # trigger load initialized
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATIONS_LOAD
    )

    # init load
    orchestrationsApi
      .getOrchestrations()
      .then((orchestrations) ->
        # load success
        dispatcher.handleViewAction(
          type: constants.ActionTypes.ORCHESTRATIONS_LOAD_SUCCESS
          orchestrations: orchestrations
        )
      )

  loadOrchestration: (id) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATION_LOAD
      orchestrationId: id
    )

    orchestrationsApi
      .getOrchestration(id)
      .then((orchestration) ->
        dispatcher.handleViewAction(
          type: constants.ActionTypes.ORCHESTRATION_LOAD_SUCCESS
          orchestration: orchestration
        )
      )
      .catch((error) ->
        dispatcher.handleViewAction(
          type: constants.ActionTypes.ORCHESTRATION_LOAD_ERROR
          orchestrationId: id
          status: error.status
          response: error.response
        )
      )


  setOrchestrationsFilter: (query) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATIONS_SET_FILTER
      query: query
    )

  activateOrchestration: (id) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATION_ACTIVATE
      orchestrationId: id
    )

  disableOrchestration: (id) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATION_DISABLE
      orchestrationId: id
    )

