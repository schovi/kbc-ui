
Dispatcher = require('../Dispatcher.coffee')
Immutable = require('immutable')
{Map, List} = Immutable
Constants = require '../constants/KbcConstants.coffee'
StoreUtils = require '../utils/StoreUtils.coffee'

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
        notifications.unshift Immutable.fromJS(action.notification)
      NotificationsStore.emitChange()

    when Constants.ActionTypes.APPLICATION_DELETE_NOTIFICATION
      _store = _store.update 'notifications', (notifications) ->
        notifications.delete action.notificationIndex
      NotificationsStore.emitChange()

module.exports = NotificationsStore