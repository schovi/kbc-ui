dispatcher = require('../../Dispatcher')
Promise = require('bluebird')
templatesStore = require './stores/TemplatesStore'
templatesApi = require './TemplatesApi'
Constants = require('./TemplatesConstants')

module.exports =

  loadSchema: (componentId) ->
    if templatesStore.hasTemplates(componentId)
      return Promise.resolve()
    @loadSchemaForce(componentId)

  loadSchemaForce: (componentId) ->
    loadTemplateComponentId = componentId
    dispatcher.handleViewAction
      componentId: componentId
      type: Constants.ActionTypes.TEMPLATES_LOAD_START
    templatesApi.getTemplate(loadTemplateComponentId).then (result) ->
      dispatcher.handleViewAction
        componentId: componentId
        type: Constants.ActionTypes.TEMPLATES_LOAD_SUCCESS
        templates: result
      return result
    .catch ->
      dispatcher.handleViewAction
        componentId: componentId
        type: Constants.ActionTypes.TEMPLATES_LOAD_ERROR
