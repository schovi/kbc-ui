React = require 'react'
Immutable = require 'immutable'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

ExDbStore = require '../../../exDbStore'
RoutesStore = require '../../../../../stores/RoutesStore'

QueryTable = React.createFactory(require './QueryTable')
ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory ComponentDescription

LatestJobs = React.createFactory(require '../../../../components/react/components/LatestJobs')
RunExtractionButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
Link = React.createFactory(require('react-router').Link)

jobs = [
  id: 123
  status: 'processing'
  startTime: "2015-02-16T15:01:52+01:00"
  endTime: null
  token:
    id: 234
    description: "martin@keboola.com"
,
  id: 120
  status: 'success'
  startTime: "2015-02-16T16:01:52+01:00"
  endTime: "2015-02-16T15:02:23+00:00"
  token:
    id: 235
    description: "Orchestrator new"
]

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
    configurationId = @state.configuration.get('id')
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
            RunExtractionButton
              title: 'Run Extraction'
              component: 'ex-db'
              mode: 'link'
              runParams: ->
                config: configurationId
            ,
              'You are about to run extraction.'

        div className: 'kbc-buttons',
          span null,
            'Created By '
          strong null, 'Martin Halamíček'
          br null
          span null,
            'Created On '
          strong null, '2014-05-07 09:24 '

        LatestJobs
          jobs: Immutable.fromJS jobs
