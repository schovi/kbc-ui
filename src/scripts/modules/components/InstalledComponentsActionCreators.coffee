

dispatcher = require '../../Dispatcher.coffee'
constants = require '../../constants/KbcConstants.coffee'

InstalledComponentsStore = require './stores/InstalledComponentsStore.coffee'
installedComponentsApi = require './installedComponentsApi.coffee'


module.exports =

  loadComponents: ->
    return if InstalledComponentsStore.getIsLoaded()
    @loadComponentsForce()


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


  receiveAllComponents: (componentsRaw) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_SUCCESS
      components: componentsRaw
    )