

dispatcher = require '../dispatcher/KbcDispatcher.coffee'
constants = require '../constants/KbcConstants.coffee'


request = require 'superagent'


module.exports =

  loadOrchestrations: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.ORCHESTRATIONS_LOAD
    )

    request
      .get('https://syrup.keboola.com/orchestrator/orchestrations')
      .set('X-StorageApi-Token', 'token')
      .end((response) ->
        dispatcher.handleViewAction(
          type: constants.ActionTypes.ORCHESTRATIONS_LOAD_SUCCESS
          orchestrations: response.body
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

