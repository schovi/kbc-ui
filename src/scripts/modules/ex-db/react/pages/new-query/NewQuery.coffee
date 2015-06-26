React = require 'react'
Map = require('immutable').Map
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

ExDbStore = require '../../../exDbStore'
RoutesStore = require '../../../../../stores/RoutesStore'
ExDbActionCreators = require '../../../exDbActionCreators'
StorageTablesStore = require '../../../../components/stores/StorageTablesStore'

QueryEditor = React.createFactory(require '../../components/QueryEditor')



module.exports = React.createClass
  displayName: 'ExDbNewQuery'
  mixins: [createStoreMixin(ExDbStore, StorageTablesStore)]

  getStateFromStores: ->
    configId = RoutesStore.getRouterState().getIn ['params', 'config']
    configId: configId
    newQuery: ExDbStore.getNewQuery configId
    tables: StorageTablesStore.getAll()

  _handleQueryChange: (newQuery) ->
    ExDbActionCreators.updateNewQuery @state.configId, newQuery

  render: ->
    React.DOM.div className: 'container-fluid kbc-main-content',
      QueryEditor
        query: @state.newQuery
        tables: @state.tables
        onChange: @_handleQueryChange
