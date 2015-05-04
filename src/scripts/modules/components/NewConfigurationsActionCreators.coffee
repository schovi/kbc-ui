

dispatcher = require '../../Dispatcher'
constants = require './Constants'

NewConfigurationsStore = require './stores/NewConfigurationsStore'

createComponentConfiguration = require './utils/createComponentConfiguration'
transitionToComponentConfiguration = require './utils/componentConfigurationTransition'

RoutesStore = require '../../stores/RoutesStore'
ComponentsStore = require './stores/ComponentsStore'

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

    component = ComponentsStore.getComponent componentId
    RoutesStore.getRouter().transitionTo "new-#{component.get('type')}"


  saveConfiguration: (componentId) ->
    configuration = NewConfigurationsStore.getConfiguration componentId

    dispatcher.handleViewAction
      type: constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_START
      componentId: componentId

    createComponentConfiguration componentId, configuration
    .then (response) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_SUCCESS
        componentId: componentId
        component: ComponentsStore.getComponent(componentId)
        configuration: response
      transitionToComponentConfiguration(componentId, response.id)
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.COMPONENTS_NEW_CONFIGURATION_SAVE_ERROR
        componentId: componentId
        error: e
      throw e
