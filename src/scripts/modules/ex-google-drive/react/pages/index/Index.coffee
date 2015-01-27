React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
#ExGdriveStore = require '../../../exGdriveStore.coffee'

{div,span} = React.DOM
module.exports = React.createClass
  getStateFromStores: ->
    config = RoutesStore.getRouterState().getIn ['params', 'config']
    configuration: []



  render: ->
    div {}, "blabla"
