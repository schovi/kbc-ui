
Dispatcher = require('../Dispatcher')
Immutable = require('immutable')
{Map, List} = Immutable
Constants = require '../constants/KbcConstants'
StoreUtils = require '../utils/StoreUtils'

_store = Map
  notifications: List()


NotificationsStore = StoreUtils.createStore

  getNotifications: ->
    _store.get 'notifications'

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.APPLICATION_SEND_NOTIFICATION
      _store = _store.update 'notifications', (notifications) ->
        notifications.unshift Map(action.notification)
      NotificationsStore.emitChange()

    when Constants.ActionTypes.APPLICATION_DELETE_NOTIFICATION
      _store = _store.update 'notifications', (notifications) ->
        notifications.delete action.notificationIndex
      NotificationsStore.emitChange()

module.exports = NotificationsStore