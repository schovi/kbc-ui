React = require 'react'

{button, span} = React.DOM

Link = React.createFactory(require('react-router').Link)
RoutesStore = require('../../../../stores/RoutesStore.coffee')
ComponentsStore = require('../../stores/ComponentsStore.coffee')
createStoreMixin = require('../../../../react/mixins/createStoreMixin.coffee')


module.exports = React.createClass
  displayName: 'AddComponentConfigurationButton'

  mixins: [createStoreMixin(ComponentsStore)]

  getStateFromStores: ->
    componentId = RoutesStore.getCurrentRouteParam('componentId')
    component = ComponentsStore.getComponent(componentId)

    response =
      component: component

    response

  render: ->
    route = 'new-application-form'
    if this.state.component.get('type') == 'extractor'
      route = 'new-extractor-form'
    if this.state.component.get('type') == 'writer'
      route = 'new-writer-form'

    Link
      to: route
      params:
        componentId: this.state.component.get('id')
      className: 'btn btn-success'
      activeClassName: ''
    ,
      span className: 'kbc-icon-plus'
      'Add Configuration'
