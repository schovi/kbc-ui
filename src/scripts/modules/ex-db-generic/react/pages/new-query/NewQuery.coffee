React = require 'react'
Map = require('immutable').Map
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

storeProvisioning = require '../../../storeProvisioning'
actionsProvisioning = require '../../../actionsProvisioning'

RoutesStore = require '../../../../../stores/RoutesStore'
StorageTablesStore = require '../../../../components/stores/StorageTablesStore'

QueryEditor = React.createFactory(require '../../components/QueryEditor')

module.exports = (componentId) ->
  ExDbActionCreators = actionsProvisioning.createActions(componentId)
  React.createClass
    displayName: 'ExDbNewQuery'
    mixins: [createStoreMixin(storeProvisioning.componentsStore, StorageTablesStore)]

    getStateFromStores: ->
      configId = RoutesStore.getRouterState().getIn ['params', 'config']
      ExDbStore = storeProvisioning.createStore(componentId, configId)
      newQuery = ExDbStore.getNewQuery()

      configId: configId
      newQuery: newQuery
      tables: StorageTablesStore.getAll()
      defaultOutputTable: ExDbStore.getDefaultOutputTableId(newQuery)
      outTableExist: ExDbStore.outTableExist(newQuery)

    _handleQueryChange: (newQuery) ->
      ExDbActionCreators.updateNewQuery @state.configId, newQuery

    render: ->
      React.DOM.div className: 'container-fluid kbc-main-content',
        QueryEditor
          query: @state.newQuery
          tables: @state.tables
          onChange: @_handleQueryChange
          configId: @state.configId
          defaultOutputTable: @state.defaultOutputTable
          componentId: componentId
          outTableExist: @state.outTableExist
