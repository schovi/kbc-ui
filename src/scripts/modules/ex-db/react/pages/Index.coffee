React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin.coffee'

ExDbStore = require '../../exDbStore.coffee'
RoutesStore = require '../../../../stores/RoutesStore.coffee'

{div, table, tbody, tr, td, ul, li, a, span, h2, p} = React.DOM


module.exports = React.createClass
  displayName: 'ExDbIndex'
  mixins: [createStoreMixin(ExDbStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    config = RoutesStore.getRouterState().getIn ['params', 'config']
    configuration: ExDbStore.getConfig config

  render: ->
    div className: 'container-fluid',
      'Ex db TODO'
