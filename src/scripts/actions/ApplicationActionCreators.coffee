

dispatcher = require '../Dispatcher.coffee'
constants = require '../constants/KbcConstants.coffee'


module.exports =

  receiveApplicationData: (data) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.APPLICATION_DATA_RECEIVED
      applicationData: data
    )

