
Dispatcher = require('../Dispatcher')
Immutable = require('immutable')
{Map, List} = Immutable
{ActionPhases} = require '../constants/KbcConstants'
StoreUtils = require '../utils/StoreUtils'
_ = require 'underscore'

_store = Map
  pending: Map()


PendingActionsStore = StoreUtils.createStore

  isPending: (action) ->
    _store.getIn ['pending', action], false

Dispatcher.register (payload) ->
  action = payload.action

  switch action.phase
    when ActionPhases.START
      _store = _store.setIn ['pending', action.type], true
      console.log 'pending', _store.toJS()
      PendingActionsStore.emitChange()

    when ActionPhases.SUCCESS, ActionPhases.ERROR
      _store = _store.deleteIn ['pending', action.type]
      console.log 'pending', _store.toJS()
      PendingActionsStore.emitChange()

, _.keys(ActionPhases)

module.exports = PendingActionsStore