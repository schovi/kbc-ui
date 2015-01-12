React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

ExDbStore = require '../../../exDbStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

QueryRow = React.createFactory(require './QueryRow.coffee')

{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong} = React.DOM


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

