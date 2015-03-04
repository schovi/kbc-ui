React = require 'react'

exGanalStore = require('../../../exGanalStore')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ExGanalActionCreators  = require '../../../exGanalActionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'
QueryEditor = React.createFactory(require '../../components/QueryEditor')

{div} = React.DOM
module.exports = React.createClass
  displayName: 'ExGanalQueryDetail'
  mixins: [createStoreMixin(exGanalStore)]

  getStateFromStores: ->
    configId = RoutesStore.getRouterState().getIn ['params', 'config']
    name = RoutesStore.getRouterState().getIn ['params', 'name']
    config = exGanalStore.getConfig(configId)
    configId: configId
    query: exGanalStore.getQuery(configId, name)
    editingQuery: exGanalStore.getEditingQuery(configId, name)
    name: name
    isEditing: exGanalStore.isQueryEditing(configId, name)
    profiles: config.get 'items'
    validation: exGanalStore.getQueryValidation(configId, name)

  render: ->
    console.log 'rendering query', @state.query.toJS()
    if @state.isEditing
      QueryEditor
        configId: @state.configId
        onChange: @_onQueryChange
        query: @state.editingQuery
        profiles: @state.profiles
        validation: @state.validation

    div {}, 'static query detail'


  _onQueryChange: (newQuery) ->
    console.log "query changed", newQuery.toJS()
    ExGanalActionCreators.changeQuery(@state.configId, name, newQuery)
