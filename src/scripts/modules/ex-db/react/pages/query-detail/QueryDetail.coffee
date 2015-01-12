React = require 'react'
CodeEditor  = React.createFactory(require('../../../../../react/common/common.coffee').CodeEditor)

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

ExDbStore = require '../../../exDbStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

Check = React.createFactory(require('../../../../../react/common/common.coffee').Check)

{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong} = React.DOM


module.exports = React.createClass
  displayName: 'ExDbQueryDetail'
  mixins: [createStoreMixin(ExDbStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    config = RoutesStore.getRouterState().getIn ['params', 'config']
    query = RoutesStore.getRouterState().getIn ['params', 'query']
    query: ExDbStore.getConfigQuery config, query

  render: ->
    div className: 'container-fluid',
      div className: 'table kbc-table-border-vertical kbc-detail-table',
        div className: 'tr',
          div className: 'td',
            div className: 'row',
              span className: 'col-md-3', 'Output table '
              strong className: 'col-md-9',
                @state.query.get 'outputTable'
          div className: 'td',
            div className: 'row',
              span className: 'col-md-3', 'Primary key '
              strong className: 'col-md-9',
                @state.query.get 'primaryKey'
            div className: 'row',
              span className: 'col-md-3', 'Incremental '
              strong className: 'col-md-9',
                Check isChecked: @state.query.get 'incremental'
      div null,
        CodeEditor
          value: @state.query.get 'query'