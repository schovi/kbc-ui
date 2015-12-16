dispatcher = require('../../Dispatcher')
Promise = require('bluebird')
schemasStore = require './stores/SchemasStore'
schemasApi = require './SchemasApi'
Constants = require('./SchemasConstants')
Immutable = require('immutable')

module.exports =

  loadSchema: (componentId) ->
    if schemasStore.hasSchema(componentId)
      return Promise.resolve()
    @loadSchemaForce(componentId)

  loadSchemaForce: (componentId) ->
    loadSchemaComponentId = componentId
    dispatcher.handleViewAction
      componentId: componentId
      type: Constants.ActionTypes.SCHEMA_LOAD_START
    schemasApi.getSchema(loadSchemaComponentId).then (result) ->
      dispatcher.handleViewAction
        componentId: componentId
        type: Constants.ActionTypes.SCHEMA_LOAD_SUCCESS
        schema: result
      return result
    .catch ->
      dispatcher.handleViewAction
        componentId: componentId
        type: Constants.ActionTypes.SCHEMA_LOAD_ERROR
