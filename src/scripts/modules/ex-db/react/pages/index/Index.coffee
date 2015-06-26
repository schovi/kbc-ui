React = require 'react'
Immutable = require 'immutable'
{Map} = Immutable

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

ExDbStore = require '../../../exDbStore'
RoutesStore = require '../../../../../stores/RoutesStore'
LatestJobsStore = require '../../../../jobs/stores/LatestJobsStore'

QueryTable = React.createFactory(require './QueryTable')
ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentMetadata = require '../../../../components/react/components/ComponentMetadata'

DeleteConfigurationButton = require '../../../../components/react/components/DeleteConfigurationButton'

LatestJobs = React.createFactory(require '../../../../components/react/components/SidebarJobs')
RunExtractionButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
Link = React.createFactory(require('react-router').Link)



{div, table, tbody, tr, td, ul, li, i, a, p, span, h2, p, strong, br, button} = React.DOM


module.exports = React.createClass
  displayName: 'ExDbIndex'
  mixins: [createStoreMixin(ExDbStore, LatestJobsStore)]

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    config = RoutesStore.getRouterState().getIn ['params', 'config']
    configuration = ExDbStore.getConfig config
    configuration: configuration
    pendingActions: ExDbStore.getQueriesPendingActions config
    latestJobs: LatestJobsStore.getJobs 'ex-db', config
    hasCredentials: !!configuration.getIn ['credentials', 'host']

  render: ->
    configurationId = @state.configuration.get('id')
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
        div className: 'row kbc-header',
          div className: 'col-sm-8',
            React.createElement ComponentDescription,
              componentId: 'ex-db'
              configId: @state.configuration.get('id')
          div className: 'col-sm-4 kbc-buttons',
            if @state.configuration.get('queries').count() >= 1
              Link
                to: 'ex-db-new-query'
                params:
                  config: @state.configuration.get 'id'
                className: 'btn btn-success'
              ,
                span className: 'kbc-icon-plus'
                ' Add Query'
        if !@state.hasCredentials
          div className: 'row component-empty-state text-center',
            p null,
              'Please setup database credentials for this extractor'
            Link
              to: 'ex-db-new-credentials'
              params:
                config: @state.configuration.get 'id'
            ,
              button className: 'btn btn-success',
                'Setup Database Credentials'
        if @state.configuration.get('queries').count()
          QueryTable
            configuration: @state.configuration
            pendingActions: @state.pendingActions
        else
          div className: 'row component-empty-state text-center',
            p null,
              'No queries configured yet.'
            Link
              to: 'ex-db-new-query'
              params:
                config: @state.configuration.get 'id'
              className: 'btn btn-success'
            ,
              span className: 'kbc-icon-plus'
              ' Add Query'
      div className: 'col-md-3 kbc-main-sidebar',
        div className: 'kbc-buttons kbc-text-light',
          React.createElement ComponentMetadata,
            componentId: 'ex-db'
            configId: @state.configuration.get 'id'

        ul className: 'nav nav-stacked',
          if @state.hasCredentials
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
          li null,
            React.createElement DeleteConfigurationButton,
              componentId: 'ex-db'
              configId: @state.configuration.get 'id'

        LatestJobs
          jobs: @state.latestJobs
