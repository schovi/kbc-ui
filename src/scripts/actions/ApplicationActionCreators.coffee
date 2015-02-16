

dispatcher = require '../Dispatcher'
constants = require '../constants/KbcConstants'


module.exports =

  receiveApplicationData: (data) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_DATA_RECEIVED
      applicationData: data

  ###
    notification - React element
  ###
  sendNotification: (notification) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_SEND_NOTIFICATION
      notification:
        value: notification
        type: 'info'

  deleteNotification: (notificationIndex) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_DELETE_NOTIFICATION
      notificationIndex: notificationIndex


