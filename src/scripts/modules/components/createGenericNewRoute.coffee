React = require 'react'
injectProps = require('./react/injectProps').default

NewComponentFormPage = require './react/pages/new-component-form/NewComponentForm'
ComponentsActionCreators = require './ComponentsActionCreators'

module.exports = (componentId) ->
  name: componentId + '-new'
  path: componentId + '/new'
  defaultRouteHandler: injectProps(component: componentId)(NewComponentFormPage)
  requireData: ->
    ComponentsActionCreators.loadComponent componentId
