

dispatcher = require '../Dispatcher'
constants = require '../constants/KbcConstants'
_ = require 'underscore'


module.exports =

  receiveApplicationData: (data) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_DATA_RECEIVED
      applicationData: data

  ###
    notification - React element
  ###
  sendNotification: (notification, type = 'success', id = null, autoDelete = false) ->
    notification =
      value: notification
      type: type
      id: if id then id else _.uniqueId('notification')

    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_SEND_NOTIFICATION
      notification: notification

    if autoDelete
      setTimeout @deleteNotification.bind(@, notification.id), 10000

  deleteNotification: (id) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_DELETE_NOTIFICATION
      notificationId: id


