React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

ExDbStore = require '../../../exDbStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

QueryTable = React.createFactory(require './QueryTable.coffee')
ComponentDescription = require '../../../../components/react/components/ComponentDescription.coffee'
ComponentDescription React.createFactory ComponentDescription
RunExtraction = React.createFactory(require '../../components/RunExtraction.coffee')
Link = React.createFactory(require('react-router').Link)


{div, table, tbody, tr, td, ul, li, i, a, span, h2, p, strong, br} = React.DOM


module.exports = React.createClass
  displayName: 'ExDbIndex'
  mixins: [createStoreMixin(ExDbStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    config = RoutesStore.getRouterState().getIn ['params', 'config']
    configuration: ExDbStore.getConfig config
    deletingQueries: ExDbStore.getDeletingQueries config

  render: ->
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
        div className: 'row kbc-header',
          div className: 'col-sm-8',
            ComponentDescription
              componentId: 'ex-db'
              configId: @state.configuration.get('id')
          div className: 'col-sm-4 kbc-buttons',
            Link
              to: 'ex-db-new-query'
              params:
                config: @state.configuration.get 'id'
              className: 'btn btn-success'
            ,
              span className: 'kbc-icon-plus'
              ' Add Query'
        if @state.configuration.get('queries').count()
          QueryTable
            configuration: @state.configuration
            deletingQueries: @state.deletingQueries
        else
          'No queries yet'
      div className: 'col-md-3 kbc-main-sidebar',
        ul className: 'nav nav-stacked',
          li null,
            Link
              to: 'ex-db-credentials'
              params:
                config: @state.configuration.get 'id'
            ,
              i className: 'fa fa-fw fa-user'
              ' Database Credentials'
          li null,
            RunExtraction
              configId: @state.configuration.get 'id'

        div className: 'kbc-buttons',
          span null,
            'Created By '
          strong null, 'Martin Halamíček'
          br null
          span null,
            'Created On '
          strong null, '2014-05-07 09:24 '

