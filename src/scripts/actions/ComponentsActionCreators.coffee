

dispatcher = require '../dispatcher.coffee'
constants = require '../constants/KbcConstants.coffee'


module.exports =

  setComponentsFilter: (query, componentType) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.COMPONENTS_SET_FILTER
      query: query
      componentType: componentType
    )

  receiveAllComponents: (componentsRaw) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.COMPONENTS_LOAD_SUCCESS
      components: componentsRaw
    )