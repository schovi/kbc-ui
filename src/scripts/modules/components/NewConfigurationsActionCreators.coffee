

dispatcher = require '../../Dispatcher'
constants = require './Constants'

NewConfigurationsStore = require './stores/NewConfigurationsStore'

createComponentConfiguration = require './utils/createComponentConfiguration'
transitionToComponentConfiguration = require './utils/componentConfigurationTransition'

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

    createComponentConfiguration componentId, configuration
    .then (response) ->
      console.log 'created', response
      dispatcher.handleViewAction
        type: constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_SUCCESS
        componentId: componentId
        configuration: response
      transitionToComponentConfiguration(componentId, response.id)
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_ERROR
        componentId: componentId
        error: e
      throw e
