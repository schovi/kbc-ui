React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

ExDbStore = require '../../../exDbStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

QueryDetailEditing = React.createFactory(require './QueryDetailEditing.coffee')
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

  render: ->
    if @state.isEditing
      QueryDetailEditing
        query: @state.editingQuery
        configId: @state.configId
    else
      QueryDetailStatic
        query: @state.query
