assign = require 'object-assign'
Dispatcher = require('flux').Dispatcher
{PayloadSources, ActionPhases} = require('./constants/KbcConstants')


class KbcDispatcher extends Dispatcher

  dispatch: (payload) ->
    console.log 'dispatch', payload.action.type, payload.action.phase
    super payload

  ###
    by default - Accepts only success actions = all sync actions and success async actions
  ###
  register: (callback, phases = [ActionPhases.SUCCESS]) ->
    super (payload) ->
      if payload.action.phase in phases
        callback arguments...

  registerAllPhases: (callback) ->
    super callback

  handleViewAction: (action) ->
    payload =
      action: action

    if !payload.action.phase
      payload.action.phase = ActionPhases.SUCCESS

    @dispatch payload

  handleAsyncAction: (action, promise) ->
    @dispatch
      action:
        phase: ActionPhases.START
        type: action

    promise
    .then (data) =>
      @dispatch
        action:
          type: action
          phase: ActionPhases.SUCCESS
          data: data
    .catch (e) =>
      @dispatch
        action:
          type: action
          phase: ActionPhases.ERROR
          error: data


module.exports = new KbcDispatcher()