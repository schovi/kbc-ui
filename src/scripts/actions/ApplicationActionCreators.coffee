dispatcher = require '../Dispatcher'
constants = require '../constants/KbcConstants'
_ = require 'underscore'


module.exports =

  receiveApplicationData: (data) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_DATA_RECEIVED
      applicationData: data

  ###
    notification -
      text - (required) notification message string or React element
      type - notification type, default is success
      id - notification id, used for duplicate messages filter
  ###
  sendNotification: (notification) ->
    timeout = 10000
    defaults =
      pause: false
      message: ''
      type: 'success'
      autoDelete: false
      id: _.uniqueId('notification')
      created: new Date()
      timeout: timeout

    if !notification.id?
      delete notification.id

    notification = _.extend defaults, notification

    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_SEND_NOTIFICATION
      notification: notification

    setTimeout @deleteNotification.bind(@, notification.id), timeout

  deleteNotification: (id, forceDelete) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_DELETE_NOTIFICATION
      notificationId: id
      forceDelete: forceDelete


  pauseNotificationAging: (id) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_SET_PAUSE_NOTIFICATION
      notificationId: id
      paused: true

  resetNotificationAging: (id) ->
    timeout = 10000
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_SET_PAUSE_NOTIFICATION
      notificationId: id
      paused: false
    setTimeout @deleteNotification.bind(@, id), timeout
