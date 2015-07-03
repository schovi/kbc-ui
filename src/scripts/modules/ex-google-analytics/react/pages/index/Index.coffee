React = require 'react'
classnames = require 'classnames'
ComponentMetadata = require '../../../../components/react/components/ComponentMetadata'
LatestJobs = require '../../../../components/react/components/SidebarJobs'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ExGanalStore = require '../../../exGanalStore'
RoutesStore = require '../../../../../stores/RoutesStore'
ApplicationStore = require '../../../../../stores/ApplicationStore.coffee'
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

{p, strong, br, ul, li, div, span, i} = React.DOM

module.exports = React.createClass
  displayName: 'ExGanalIndex'
  mixins: [createStoreMixin(ExGanalStore, LatestJobsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    config = ExGanalStore.getConfig(configId)
    currentUser = ApplicationStore.getSapiToken().get('description')
    currentUser: currentUser
    owner: config.get 'owner'
    config: config
    configId: configId
    since: moment().subtract(4, 'day')
    until: moment()
    latestJobs: LatestJobsStore.getJobs 'ex-google-analytics', configId
    selectedProfilesCount: ExGanalStore.getSelectedProfiles(configId)?.count() || 0

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
          if queries.count()
            @_renderAddQueryButton()
      if queries.count()
        QueriesTable
          config: @state.config
          queries: queries
          profiles: @state.config.get 'items'
          configId: @state.configId
          isQueryDeleting: (queryName) =>
            ExGanalStore.isDeletingQueries(@state.configId, queryName)

      else
        div className: 'row component-empty-state text-center',
          if @_isAuthorized()
            div null,
              p null, 'No queries configured yet.'
              @_renderAddQueryButton()
        ,
          if not @_isAuthorized()
            div null,
              p null, 'No Google account authorized.'
              Link
                className: 'btn btn-success'
                to: 'ex-google-analytics-authorize'
                params:
                  config: @state.config.get 'id'
              ,
                i className: 'fa fa-fw fa-user'
                ' Authorize Google Account'

  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      div className: 'kbc-buttons kbc-text-light',
        span null,
          'Authorized for '
        strong null,
          @_getAuthorizedForCaption()
        React.createElement ComponentMetadata,
          componentId: 'ex-google-analytics'
          configId: @state.configId
      ul className: 'nav nav-stacked',
        if @_showAuthorize()
          li null,
            Link
              to: 'ex-google-analytics-authorize'
              params:
                config: @state.configId
            ,
              i className: 'fa fa-fw fa-user'
              'Authorize'
        if @_isExtLinkOnly()
          li null,
            Link
              to: 'ex-google-analytics-authorize'
              params:
                config: @state.configId
            ,
              i className: 'fa fa-fw fa-user'
              'Resend External Link'
        if @_showSelectProfiles()
          li null,
            Link
              to: 'ex-google-analytics-select-profiles'
              params:
                config: @state.configId
            ,
              span className: 'fa fa-fw fa-globe'
              'Profiles '
              span className: 'badge',
                @state.selectedProfilesCount

        li null,
          ModalTrigger
            modal: OptionsModal
              configId: @state.configId
              outputBucket: ExGanalStore.getOutputBucket @state.configId
          ,
            span className: 'btn btn-link',
              i className: 'fa fa-fw fa-gear'
              ' Options'
        li {className: classnames(disabled: !@state.config.get('configuration')?.count())},
          RunButtonModal
            title: 'Run Extraction'
            mode: 'link'
            component: 'ex-google-analytics'
            disabled: !@state.config.get('configuration')?.count()
            disabledReason: "No queries configured."
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
      React.createElement LatestJobs,
        jobs: @state.latestJobs

  _getAuthorizedForCaption: ->
    result = ''
    if @_isAuthorized()
      result = @state.config.get 'email'
      if @_isExtLinkOnly()
        result = "externally #{result}"
    else
      result = 'not authorized'
    return result

  _isAuthorized: ->
    @state.config.has 'email'

  _showAuthorize: ->
    (not @state.owner)

  _isCurrentAuthorized: ->
    (@state.currentUser == @state.owner or (@state.currentUser == @state.config.get 'email')) and @state.owner != null


  _isExtLinkOnly: ->
    @state.config.get('external') == '1'

  _showSelectProfiles: ->
    @_isCurrentAuthorized() and not @_isExtLinkOnly()

  _renderAddQueryButton: ->
    if @_isAuthorized()
      Link
        to: 'ex-google-analytics-new-query'
        params:
          config: @state.configId
        className: 'btn btn-success'
      ,
        i className: 'fa fa-fw fa-plus'
        'Add Query'
