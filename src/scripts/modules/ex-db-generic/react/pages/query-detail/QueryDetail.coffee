React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

storeProvisioning = require '../../../storeProvisioning'
actionsProvisioning = require '../../../actionsProvisioning'

StorageTablesStore = require '../../../../components/stores/StorageTablesStore'
RoutesStore = require '../../../../../stores/RoutesStore'

QueryEditor = React.createFactory(require '../../components/QueryEditor')
QueryDetailStatic = React.createFactory(require './QueryDetailStatic')
QueryNav = require('./QueryNav').default
EditButtons = require '../../../../../react/common/EditButtons'


{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong} = React.DOM

module.exports = (componentId) ->
  ExDbActionCreators = actionsProvisioning.createActions(componentId)
  return React.createClass
    displayName: 'ExDbQueryDetail'
    mixins: [createStoreMixin(storeProvisioning.componentsStore, StorageTablesStore)]

    componentWillReceiveProps: ->
      @setState(@getStateFromStores())

    getStateFromStores: ->
      configId = RoutesStore.getCurrentRouteParam 'config'
      queryId = RoutesStore.getCurrentRouteIntParam 'query'
      ExDbStore = storeProvisioning.createStore(componentId, configId)
      isEditing = ExDbStore.isEditingQuery(queryId)

      configId: configId
      query: ExDbStore.getConfigQuery(queryId)
      editingQuery: ExDbStore.getEditingQuery(queryId)
      isEditing: isEditing
      isSaving: ExDbStore.isSavingQuery()
      isValid: ExDbStore.isEditingQueryValid(queryId)
      tables: StorageTablesStore.getAll()
      queriesFilter: ExDbStore.getQueriesFilter()
      queriesFiltered: ExDbStore.getQueriesFiltered()

    _handleQueryChange: (newQuery) ->
      ExDbActionCreators.updateEditingQuery @state.configId, newQuery

    _handleEditStart: ->
      ExDbActionCreators.editQuery @state.configId, @state.query.get('id')

    _handleCancel: ->
      ExDbActionCreators.cancelQueryEdit @state.configId, @state.query.get('id')

    _handleSave: ->
      ExDbActionCreators.saveQueryEdit @state.configId, @state.query.get('id')

    render: ->
      div className: 'container-fluid kbc-main-content',
        div className: 'col-md-3 kbc-main-nav',
          div className: 'kbc-container',
            React.createElement QueryNav,
              queries: @state.queriesFiltered
              configurationId: @state.configId
              filter: @state.queriesFilter
              componentId: componentId
        div className: 'col-md-9 kbc-main-content-with-nav',
          div className: 'row kbc-header',
            div className: 'kbc-buttons',
              React.createElement EditButtons,
                isEditing: @state.isEditing
                isSaving: @state.isSaving
                isDisabled: !@state.isValid
                onCancel: @_handleCancel
                onSave: @_handleSave
                onEditStart: @_handleEditStart
          if @state.isEditing
            QueryEditor
              query: @state.editingQuery
              tables: @state.tables
              onChange: @_handleQueryChange
              configId: @state.configId
              componentId: componentId
          else
            QueryDetailStatic
              query: @state.query
              componentId: componentId
