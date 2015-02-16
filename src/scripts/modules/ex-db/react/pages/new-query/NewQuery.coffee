React = require 'react'
Map = require('immutable').Map
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

ExDbStore = require '../../../exDbStore'
RoutesStore = require '../../../../../stores/RoutesStore'
ExDbActionCreators = require '../../../exDbActionCreators'

QueryEditor = React.createFactory(require '../../components/QueryEditor')

{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong} = React.DOM


module.exports = React.createClass
  displayName: 'ExDbNewQuery'
  mixins: [createStoreMixin(ExDbStore)]

  getStateFromStores: ->
    configId = RoutesStore.getRouterState().getIn ['params', 'config']
    configId: configId
    newQuery: ExDbStore.getNewQuery configId

  _handleQueryChange: (newQuery) ->
    ExDbActionCreators.updateNewQuery @state.configId, newQuery

  render: ->
    QueryEditor
      query: @state.newQuery
      onChange: @_handleQueryChange
