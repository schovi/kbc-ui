

dispatcher = require '../../Dispatcher'
constants = require './Constants'


module.exports =


  updateConfiguration: (componentId, configuration) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_UPDATE
      componentId: componentId
      configuration: configuration

  resetConfiguration: (componentId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_CANCEL
      componentId: componentId