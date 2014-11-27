

dispatcher = require '../dispatcher/KbcDispatcher.coffee'
constants = require '../constants/KbcConstants.coffee'

installedComponentsApi = require '../apis/installedComponentsApi.coffee'

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


  receiveAllComponents: (componentsRaw) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_SUCCESS
      components: componentsRaw
    )