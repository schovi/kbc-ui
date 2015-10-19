React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

ExDbStore = require '../../../exDbStore'
StorageTablesStore = require '../../../../components/stores/StorageTablesStore'
RoutesStore = require '../../../../../stores/RoutesStore'

ExDbActionCreators = require '../../../exDbActionCreators'

QueryEditor = React.createFactory(require '../../components/QueryEditor')
QueryDetailStatic = React.createFactory(require './QueryDetailStatic')
QueryNav = require './QueryNav'
EditButtons = require '../../../../../react/common/EditButtons'


{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong} = React.DOM


module.exports = React.createClass
  displayName: 'ExDbQueryDetail'
  mixins: [createStoreMixin(ExDbStore, StorageTablesStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam 'config'
    queryId = RoutesStore.getCurrentRouteIntParam 'query'
    isEditing = ExDbStore.isEditingQuery configId, queryId

    configId: configId
    driver: ExDbStore.getConfig(configId).getIn(['credentials', 'driver'])
    query: ExDbStore.getConfigQuery configId, queryId
    editingQuery: ExDbStore.getEditingQuery configId, queryId
    isEditing: isEditing
    isSaving: ExDbStore.isSavingQuery configId, queryId
    isValid: ExDbStore.isEditingQueryValid configId, queryId
    tables: StorageTablesStore.getAll()
    queriesFilter: ExDbStore.getQueriesFilter(configId)
    queriesFiltered: ExDbStore.getQueriesFiltered(configId)

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
            driver: @state.driver
        else
          QueryDetailStatic
            query: @state.query
            driver: @state.driver
