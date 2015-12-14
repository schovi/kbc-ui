

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

  deleteNotification: (id) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_DELETE_NOTIFICATION
      notificationId: id


