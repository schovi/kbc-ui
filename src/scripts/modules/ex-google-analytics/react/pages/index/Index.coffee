React = require 'react'
ComponentMetadata = require '../../../../components/react/components/ComponentMetadata'
LatestJobs = require '../../../../components/react/components/SidebarJobs'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ExGanalStore = require '../../../exGanalStore'
RoutesStore = require '../../../../../stores/RoutesStore'
QueriesTable = React.createFactory(require('./QueriesTable'))
OptionsModal = React.createFactory(require('./OptionsModal'))
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))
ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)
Link = React.createFactory(require('react-router').Link)
RunDatePicker = React.createFactory require('../../components/DatePicker')
moment = require 'moment'
DeleteConfigurationButton = require '../../../../components/react/components/DeleteConfigurationButton'
DeleteConfigurationButton = React.createFactory DeleteConfigurationButton
LatestJobsStore = require '../../../../jobs/stores/LatestJobsStore'

{strong, br, ul, li, div, span, i} = React.DOM

module.exports = React.createClass
  displayName: 'ExGanalIndex'
  mixins: [createStoreMixin(ExGanalStore, LatestJobsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    config = ExGanalStore.getConfig(configId)
    config: config
    configId: configId
    since: moment().subtract(4, 'day')
    until: moment()
    latestJobs: LatestJobsStore.getJobs 'ex-google-analytics', configId

  render: ->
    console.log 'rendering', @state.config.toJS()
    div {className: 'container-fluid'},
      @_renderMainContent()
      @_renderSideBar()

  _renderMainContent: ->
    queries = @state.config.get('configuration')
    div {className: 'col-md-9 kbc-main-content'},
      div className: 'row kbc-header',
        div className: 'col-sm-8',
          ComponentDescription
            componentId: 'ex-google-analytics'
            configId: @state.configId
        div className: 'col-sm-4 kbc-buttons',
          Link
            to: 'ex-google-analytics-new-query'
            params:
              config: @state.configId
            className: 'btn btn-success'
          ,
            i className: 'fa fa-fw fa-plus'
            'Add Query'
      if queries.count()
        QueriesTable
          config: @state.config
          queries: queries
          profiles: @state.config.get 'items'
          configId: @state.configId
          isQueryDeleting: (queryName) =>
            ExGanalStore.isDeletingQueries(@state.configId, queryName)

      else
        div className: 'well component-empty-state text-center',
          div null, 'No queries configured yet.'
        ,
          Link
            className: 'btn btn-primary'
            to: 'ex-google-analytics-select-profiles'
            params:
              config: @state.config.get 'id'
          ,
            i className: 'fa fa-fw fa-user'
            ' Authorize Google Account'


  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      ul className: 'nav nav-stacked',
        li null,
          Link
            to: 'ex-google-analytics-authorize'
            params:
              config: @state.configId
          ,
            i className: 'fa fa-fw fa-user'
            'Authorize'
        li null,
          Link
            to: 'ex-google-analytics-select-profiles'
            params:
              config: @state.configId
          ,
            span className: 'fa fa-fw fa-check'
            'Select Profiles'
        li null,
          ModalTrigger
            modal: OptionsModal
              configId: @state.configId
              outputBucket: ExGanalStore.getOutputBucket @state.configId
          ,
            span className: 'btn btn-link',
              i className: 'fa fa-fw fa-gear'
              ' Options'
        li null,
          RunButtonModal
            title: 'Run Extraction'
            mode: 'link'
            component: 'ex-google-analytics'
            runParams: =>
              config: @state.configId
              since: @state.since.toISOString()
              until: @state.until.toISOString()
          ,
            RunDatePicker
              since: @state.since
              until: @state.until
              onChangeFrom: (date) =>
                @setState
                  since: date
              onChangeUntil: (date) =>
                @setState
                  until: date
        li null,
          DeleteConfigurationButton
            componentId: 'ex-google-analytics'
            configId: @state.configId
      span null,
        'Authorized for: '
        strong null,
        if @_isAuthorized()
          @state.config.get 'email'
        else
          'not authorized'
      React.createElement ComponentMetadata,
        componentId: 'ex-google-analytics'
        configId: @state.configId
      React.createElement LatestJobs,
        jobs: @state.latestJobs


  _isAuthorized: ->
    @state.config.has 'email'
