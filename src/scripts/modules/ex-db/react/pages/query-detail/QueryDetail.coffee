React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

ExDbStore = require '../../../exDbStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

ExDbActionCreators = require '../../../exDbActionCreators.coffee'

QueryEditor = React.createFactory(require '../../components/QueryEditor.coffee')
QueryDetailStatic = React.createFactory(require './QueryDetailStatic.coffee')


{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong} = React.DOM


module.exports = React.createClass
  displayName: 'ExDbQueryDetail'
  mixins: [createStoreMixin(ExDbStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    configId = RoutesStore.getRouterState().getIn ['params', 'config']
    queryId = RoutesStore.getRouterState().getIn ['params', 'query']
    isEditing = ExDbStore.isEditingQuery configId, queryId
    configId: configId
    query: ExDbStore.getConfigQuery configId, queryId
    editingQuery: ExDbStore.getEditingQuery configId, queryId
    isEditing: isEditing

  _handleQueryChange: (newQuery) ->
    ExDbActionCreators.updateEditingQuery @state.configId, newQuery

  render: ->
    if @state.isEditing
      QueryEditor
        query: @state.editingQuery
        onChange: @_handleQueryChange
    else
      QueryDetailStatic
        query: @state.query
