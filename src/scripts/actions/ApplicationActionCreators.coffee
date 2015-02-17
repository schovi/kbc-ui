

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
  sendNotification: (notification, type = 'success') ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_SEND_NOTIFICATION
      notification:
        value: notification
        type: type

  deleteNotification: (notificationIndex) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_DELETE_NOTIFICATION
      notificationIndex: notificationIndex


