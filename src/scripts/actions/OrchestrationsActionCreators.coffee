

dispatcher = require '../dispatcher/KbcDispatcher.coffee'
constants = require '../constants/KbcConstants.coffee'


module.exports =

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

