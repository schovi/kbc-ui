React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

ExDbStore = require '../../../exDbStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

QueryRow = React.createFactory(require './QueryRow.coffee')
ComponentDescription = require '../../../../components/react/components/ComponentDescription.coffee'
ComponentDescription React.createFactory ComponentDescription

{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong, br} = React.DOM


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
      div className: 'row kbc-header',
        ComponentDescription
          componentId: 'ex-db'
          configId: @state.configuration.get('id')
        div className: 'kbc-buttons',
          span null,
            'Created By '
            strong null, 'Martin Halamíček'
          br null
          span null,
            'Created On '
            strong null, '2014-05-07 09:24 '
      if @state.configuration.get('queries').count()
        @_renderQueriesTable()
      else
        'No queries yet'

  _renderQueriesTable: ->
    childs = @state.configuration.get('queries').map((query) ->
      QueryRow
        query: query
        configurationId: @state.configuration.get 'id'
        key: query.get('id')
    , @).toArray()
    div className: 'table table-striped table-hover',
      @_renderTableHeader()
      div className: 'tbody',
        childs

  _renderTableHeader: ->
    div className: 'thead', key: 'table-header',
      div className: 'tr',
        span className: 'th',
          strong null, 'Output table'
        span className: 'th',
          strong null, 'Incremental'
        span className: 'th',
          strong null, 'Primary key'
        span className: 'th'

