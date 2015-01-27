React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
ExGdriveStore = require '../../../exGdriveStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

{div,span} = React.DOM
module.exports = React.createClass
  mixins: [createStoreMixin(ExGdriveStore, RoutesStore)]
  getStateFromStores: ->
    config = RoutesStore.getRouterState().getIn ['params', 'config']
    configuration: ExGdriveStore.getConfig(config)


  render: ->
    console.log @state.configuration
    div {}, "blabla"
