

dispatcher = require '../../Dispatcher'
constants = require './Constants'

NewConfigurationsStore = require './stores/NewConfigurationsStore'

componentsUtils = require './Utils'

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

  saveConfiguration: (componentId) ->
    configuration = NewConfigurationsStore.getConfiguration componentId

    dispatcher.handleViewAction
      type: constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_START
      componentId: componentId

    componentsUtils
    .createComponentConfiguration componentId, configuration
    .then (response) ->
      console.log 'created', response
      dispatcher.handleViewAction
        type: constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_SUCCESS
        componentId: componentId
        configuration: response
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_ERROR
        componentId: componentId
        error: e
      throw e
