

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
  sendNotification: (notification, type = 'success', id = null) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_SEND_NOTIFICATION
      notification:
        value: notification
        type: type
        id: id

  deleteNotification: (id) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.APPLICATION_DELETE_NOTIFICATION
      notificationId: id


