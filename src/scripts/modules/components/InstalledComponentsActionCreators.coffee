Promise = require 'bluebird'

dispatcher = require '../../Dispatcher.coffee'
constants = require './Constants.coffee'

InstalledComponentsStore = require './stores/InstalledComponentsStore.coffee'
installedComponentsApi = require './InstalledComponentsApi.coffee'

console.log 'constants', constants
module.exports =

  loadComponentsForce: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.INSTALLED_COMPONENTS_LOAD
    )

    installedComponentsApi
    .getComponents()
    .then((components) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_SUCCESS
        components: components
      )
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_ERROR
        status: error.status
        response: error.response
      )
    )

  loadComponents: ->
    return Promise.resolve() if InstalledComponentsStore.getIsLoaded()
    @loadComponentsForce()

  receiveAllComponents: (componentsRaw) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_SUCCESS
      components: componentsRaw
    )

  updateComponentConfiguration: (componentId, configurationId, data) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.INSTALLED_COMPONENTS_UPDATE_CONFIGURATION
      componentId: componentId
      configurationId: configurationId
      data: data

    installedComponentsApi
    .updateComponentConfiguration componentId, configurationId, data
    .then (response) ->
      console.log 'saved', response