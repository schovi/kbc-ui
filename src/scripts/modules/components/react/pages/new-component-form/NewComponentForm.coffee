React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ComponentsStore = require '../../../stores/ComponentsStore'

DefaultForm = React.createFactory(require './DefaultForm')


{div} = React.DOM


module.exports = React.createClass
  displayName: 'NewComponentForm'

  getInitialState: ->
    component: ComponentsStore.getComponent(RoutesStore.getCurrentRouteParam('componentId'))

  render: ->
    div className: 'container-fluid kbc-main-content',
      DefaultForm
        component: @state.component


