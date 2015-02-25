
Promise = require('bluebird')
ComponentsStore = require './stores/ComponentsStore'

dispatcher = require '../../Dispatcher'
constants = require './Constants'

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

  loadComponent: (componentId) ->
    if ComponentsStore.hasComponent(componentId)
      Promise.resolve()
    else
      Promise.reject(new Error("Component #{componentId} not exist."))

