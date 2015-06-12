
Dispatcher = require('../Dispatcher')
Immutable = require('immutable')
{Map, List} = Immutable
Constants = require '../constants/KbcConstants'
StoreUtils = require '../utils/StoreUtils'

_store = Map
  notifications: List()

hasNotificationWithId = (id) ->
  return false if !id
  found = _store.get('notifications').find (notification) ->
    notification.get('id') == id
  !! found

NotificationsStore = StoreUtils.createStore

  getNotifications: ->
    _store.get 'notifications'

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.APPLICATION_SEND_NOTIFICATION

      # avoid duplication of same message
      console.log 'not', action.notification.id
      if !hasNotificationWithId(action.notification.id)
        _store = _store
          .update 'notifications', (notifications) ->
            notifications.unshift Map(action.notification)
        NotificationsStore.emitChange()

    when Constants.ActionTypes.APPLICATION_DELETE_NOTIFICATION
      _store = _store.update 'notifications', (notifications) ->
        notifications.delete action.notificationIndex
      NotificationsStore.emitChange()

module.exports = NotificationsStore