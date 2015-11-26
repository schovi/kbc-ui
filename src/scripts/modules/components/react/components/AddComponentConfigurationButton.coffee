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
    componentId = RoutesStore.getCurrentRouteParam('component')
    component = ComponentsStore.getComponent(componentId)

    response =
      component: component

    response

  render: ->
    route = 'generic-detail-application-new'
    if this.state.component.get('type') == 'extractor'
      route = 'generic-detail-extractor-new'
    if this.state.component.get('type') == 'writer'
      route = 'generic-detail-writer-new'

    Link
      to: route
      params:
        component: this.state.component.get('id')
      className: 'btn btn-success'
      activeClassName: ''
    ,
      span className: 'kbc-icon-plus'
      'Add Configuration'
