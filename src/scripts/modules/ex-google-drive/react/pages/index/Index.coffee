React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ExGdriveStore = require '../../../exGdriveStore'
ApplicationStore = require '../../../../../stores/ApplicationStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore'
LatestJobsStore = require '../../../../jobs/stores/LatestJobsStore'

RunExtraction = React.createFactory(require '../../components/RunExtraction')
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))

DeleteConfigurationButton = require '../../../../components/react/components/DeleteConfigurationButton'
DeleteConfigurationButton = React.createFactory DeleteConfigurationButton
ComponentMetadata = require '../../../../components/react/components/ComponentMetadata'
LatestJobs = require '../../../../components/react/components/SidebarJobs'

ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)
Link = React.createFactory(require('react-router').Link)

ItemsTable = React.createFactory(require './ItemsTable')

{strong, br, ul, li, div, span, i} = React.DOM

module.exports = React.createClass
  displayName: 'ExGdriveIndex'
  mixins: [createStoreMixin(ExGdriveStore, LatestJobsStore)]

  getStateFromStores: ->
    config =  RoutesStore.getCurrentRouteParam('config')
    currentUser = ApplicationStore.getSapiToken().get('description')
    configuration = ExGdriveStore.getConfig(config)
    configuration: configuration
    currentUser: currentUser
    deletingSheets: ExGdriveStore.getDeletingSheets(config)
    latestJobs: LatestJobsStore.getJobs 'ex-google-drive', config
    owner: configuration.get 'owner'
    email: configuration.get 'email'



  render: ->
    #console.log @state.configuration.toJS()
    div {className: 'container-fluid'},
      @_renderMainContent()
      @_renderSideBar()

  _renderMainContent: ->
    items = @state.configuration.get('items')
    div {className: 'col-md-9 kbc-main-content'},
      div className: 'row',
        ComponentDescription
          componentId: 'ex-google-drive'
          configId: @state.configuration.get('id')
        if @_showSelectSheets()
          div className: 'col-sm-4 kbc-buttons',
            Link
              to: 'ex-google-drive-select-sheets'
              disabled: not @_isAuthorized()
              params:
                config: @state.configuration.get 'id'
              className: 'btn btn-success'
            ,
              span className: 'kbc-icon-plus'
              ' Select Sheets'
      if items.count()
        ItemsTable
          items: items
          configurationId: @state.configuration.get 'id'
          deletingSheets: @state.deletingSheets
      else
        div className: 'well component-empty-state text-center',
          div null, 'No sheets configured yet.'
        ,
          Link
            className: 'btn btn-primary'
            to: 'ex-google-drive-authorize'
            params:
              config: @state.configuration.get 'id'
          ,
            i className: 'fa fa-fw fa-user'
            ' Authorize Google Account'


  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      div className: 'kbc-buttons kbc-text-light',
        span null,
          'Authorized for '
        strong null,
          if @_isAuthorized()
            @state.configuration.get 'email'
          else
            'not authorized'

        React.createElement ComponentMetadata,
          componentId: 'ex-google-drive'
          configId: @state.configuration.get 'id'

      ul className: 'nav nav-stacked',
        if @_showAuthorize() and @state.email
          li null,
            Link
              to: 'ex-google-drive-authorize'
              params:
                config: @state.configuration.get 'id'
            ,
              i className: 'fa fa-fw fa-user'
              ' Authorize'
        if @_isExtLinkOnly() and @state.email
          li null,
            Link
              to: 'ex-google-drive-authorize'
              params:
                config: @state.configuration.get 'id'
            ,
              i className: 'fa fa-fw fa-user'
              ' Resend External Link'
        if @state.configuration.get('items')?.count() > 0
          li null,
            RunButtonModal
              title: 'Run Extraction'
              mode: 'link'
              component: 'ex-google-drive'
              runParams: =>
                config: @state.configuration.get 'id'
            ,
              'You are about to run the extraction of this configuration.'

        li null,
          DeleteConfigurationButton
            componentId: 'ex-google-drive'
            configId: @state.configuration.get 'id'

      React.createElement LatestJobs,
        jobs: @state.latestJobs

  _showAuthorize: ->
    (not @state.owner) && @state.email

  _isExtLinkOnly: ->
    external = @state.configuration.get 'external'
    external && external == '1'

  _isAuthorized: ->
    @state.configuration.has 'email'

  _showSelectSheets: ->
    authorized = @state.currentUser in [@state.owner, @state.email]
    authorized and not (@state.configuration.get('external') == '1')

  # _isCurrentAuthorized: ->
  #   email = @state.configuration.get 'email'
  #   emailsArray = [@state.currentUser, email]
  #   isNull = null in emailsArray or undefined in emailsArray
  #   @state.currentUser == email and not isNull
