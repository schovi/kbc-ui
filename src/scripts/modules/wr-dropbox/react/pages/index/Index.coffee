React = require 'react'
{fromJS, Map, List} = require('immutable')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
classnames = require 'classnames'
LatestJobs = require '../../../../components/react/components/SidebarJobs'
{Loader, Check} = require 'kbc-react-components'
{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'

ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)
SearchRow = require '../../../../../react/common/SearchRow'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
OAuthStore = require('../../../OAuthStore')
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
OAuthActions = require('../../../OAuthActionCreators')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
LatestJobsStore = require '../../../../jobs/stores/LatestJobsStore'
TablesByBucketsPanel = React.createFactory require('../../components/TablesByBucketsPanel')
TableRow = React.createFactory require('./TableRow')
AuthorizeModal = React.createFactory require('./AuthorizeModal')
OptionsModal = React.createFactory require('./OptionsModal')
ComponentMetadata = require '../../../../components/react/components/ComponentMetadata'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))
DeleteConfigurationButton = require '../../../../components/react/components/DeleteConfigurationButton'
DeleteConfigurationButton = React.createFactory DeleteConfigurationButton
ActivateDeactivateButton = React.createFactory(ActivateDeactivateButton)
{p, ul, li, span, button, strong, div, i} = React.DOM

componentId = 'wr-dropbox'

module.exports = React.createClass
  displayName: 'wrDropboxIndex'
  mixins: [createStoreMixin(InstalledComponentsStore, OAuthStore, LatestJobsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    configData = InstalledComponentsStore.getConfigData(componentId, configId)
    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    toggles = localState.get('bucketToggles', Map())
    savingData = InstalledComponentsStore.getSavingConfigData(componentId, configId)
    credentials = OAuthStore.getCredentials(componentId, configId)
    hasCredentials = OAuthStore.hasCredentials(componentId, configId)
    isDeletingCredentials = OAuthStore.isDeletingCredetials(componentId, configId)

    # state
    latestJobs: LatestJobsStore.getJobs(componentId, configId)
    configId: configId
    configData: configData
    localState: localState
    bucketToggles: toggles
    savingData: savingData or Map()
    credentials: credentials
    hasCredentials: hasCredentials
    isDeletingCredentials: isDeletingCredentials

  render: ->
    div {className: 'container-fluid'},
      @_renderMainContent()
      @_renderSideBar()

  _renderMainContent: ->
    div {className: 'col-md-9 kbc-main-content'},
      div className: 'row',
        ComponentDescription
          componentId: 'wr-dropbox'
          configId: @state.configId
      if @state.hasCredentials
        React.createElement SearchRow,
          className: 'row kbc-search-row'
          onChange: @_handleSearchQueryChange
          query: @state.localState.get('searchQuery')
      if @state.hasCredentials
        TablesByBucketsPanel
          renderTableRowFn: @_renderTableRow
          renderHeaderRowFn: @_renderHeaderRow
          filterFn: @_filterBuckets
          searchQuery: @state.localState.get('searchQuery')
          isTableExportedFn: @_isTableExported
          onToggleBucketFn: @_handleToggleBucket
          isBucketToggledFn: @_isBucketToggled
      else
        div className: 'row component-empty-state text-center',
          div null,
            p null, 'No Dropbox account authorized.'
            ModalTrigger
              modal: AuthorizeModal
                configId: @state.configId
            ,
              span className: 'btn btn-success',
                i className: 'fa fa-fw fa-dropbox'
                ' Authorize Dropbox Account'



  _renderTableRow: (table) ->
    TableRow
      isTableExported: @_isTableExported(table.get('id'))
      isPending: @_isPendingTable(table.get('id'))
      onExportChangeFn: =>
        @_handleExportChange(table.get('id'))
      table: table
      prepareSingleUploadDataFn: @_prepareTableUploadData

  _prepareTableUploadData: (table) ->
    tableId = table.get('id')
    storage:
      input:
        tables: [source: tableId, destination: tableId]
    parameters: @state.configData.get('parameters', Map()).toJS()

  _isPendingTable: (tableId) ->
    isSavingData = @state.savingData.has('storage')
    if not isSavingData
      return false
    path = ['storage', 'input', 'tables']
    saving = @state.savingData.getIn(path)
    config = @state.configData.getIn(path)
    isInSaving = saving.find (table) ->
      table.get('source') == tableId
    isInConfig = config.find (table) ->
      table.get('source') == tableId
    statusArray = [!!isInSaving, !!isInConfig]
    true in statusArray and false in statusArray



  _renderHeaderRow: ->
    div className: 'tr',
      span className: 'th',
        strong null, 'Table name'
    return null

  _canRunUpload: ->
    (@_getInputTables().count() > 0) and @state.hasCredentials


  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      div className: 'kbc-buttons kbc-text-light',
        span null,
          'Authorized for '
        strong null,
          if @state.hasCredentials
            @state.credentials.get('description')
          else
            'not authorized'

        React.createElement ComponentMetadata,
          componentId: componentId
          configId: @state.configId
      ul className: 'nav nav-stacked',
        li {className: classnames(disabled: !@_canRunUpload())},
          RunButtonModal
            title: 'Upload selected tables'
            icon: 'fa fa-fw fa-upload'
            mode: 'link'
            component: 'wr-dropbox'
            disabled: !@_canRunUpload()
            disabledReason: "A dropbox account must be authorized and some table selected."
            runParams: =>
              config: @state.configId
          ,
           "You are about to run upload of #{@_getInputTables().count()} selected table(s) to dropbox account"

        li null,
          if @state.hasCredentials
            @_renderResetAuthorization()
          else
            ModalTrigger
              modal: AuthorizeModal
                configId: @state.configId
            ,
              span className: 'btn btn-link',
                i className: 'fa fa-fw fa-user'
                ' Authorize'
        li null,
          ModalTrigger
            modal: OptionsModal
              parameters: @state.configData.get('parameters', Map())
              updateParamsFn: @_updateParmeters
              isUpadting: @state.savingData.has('parameters')
          ,
            span className: 'btn btn-link',
              i className: 'fa fa-fw fa-gear'
              ' Options'
        li null,
          DeleteConfigurationButton
            componentId: 'wr-dropbox'
            configId: @state.configId
            customDeleteFn: @_deleteCredentials
      React.createElement LatestJobs,
        jobs: @state.latestJobs


  _renderResetAuthorization: ->
    description = @state.credentials.get('description')
    ActivateDeactivateButton
      mode: 'link'
      activateTooltip: ''
      deactivateTooltip: 'Reset Authorization'
      isActive: true
      isPending: @state.isDeletingCredentials
      onChange: @_deleteCredentials
    React.createElement Confirm,
      text: "Do you really want to reset the authorization of #{description}? \
       Tables configured to upload will not be reset."
      title: "Reset Authorization #{description}"
      buttonLabel: 'Reset'
      onConfirm: @_deleteCredentials
    ,
      React.DOM.a null,
        if @state.isDeletingCredentials
          React.createElement Loader
        else
          React.DOM.span className: 'fa fa-fw fa-times'
        ' Reset Authorization'



  _deleteCredentials: ->
    OAuthActions.deleteCredentials(componentId, @state.configId)



  _updateParmeters: (newParameters) ->
    @_updateAndSaveConfigData(['parameters'], newParameters)

  _handleExportChange: (tableId) ->
    _handleExport = (newExportStatus) =>
      if newExportStatus
        @_addTableExport(tableId)
      else
        @_removeTableExport(tableId)
    return _handleExport

  _updateAndSaveConfigData: (path, data) ->
    newData = @state.configData.setIn(path, data)
    saveFn = InstalledComponentsActions.saveComponentConfigData
    saveFn(componentId, @state.configId, newData)

  _getInputTables: ->
    @state.configData.getIn(['storage', 'input', 'tables']) or List()

  _findInTable: (tableId) ->
    intables = @_getInputTables()
    intables = intables.filter (table) ->
      table.get('source') != tableId

  _removeTableExport: (tableId) ->
    intables = @_getInputTables()
    intables = intables.filter (table) ->
      table.get('source') != tableId
    @_updateAndSaveConfigData(['storage', 'input', 'tables'], intables)

  _addTableExport: (tableId) ->
    intables = @_getInputTables()
    jstable =
      source: tableId
      destination: tableId
    table = intables.find((table) ->
      table.get('source') == tableId)
    if not table
      table = fromJS(jstable)
      intables = intables.push table
      @_updateAndSaveConfigData(['storage', 'input', 'tables'], intables)


  _filterBuckets: (buckets) ->
    buckets = buckets.filter (bucket) ->
      bucket.get('stage') == 'out'
    return buckets


  _isTableExported: (tableId) ->
    intables = @_getInputTables()
    !!intables.find((table) ->
      table.get('source') == tableId)


  _handleToggleBucket: (bucketId) ->
    newValue = !@_isBucketToggled(bucketId)
    newToggles = @state.bucketToggles.set(bucketId, newValue)
    @_updateLocalState(['bucketToggles'], newToggles)

  _isBucketToggled: (bucketId) ->
    !!@state.bucketToggles.get(bucketId)

  _handleSearchQueryChange: (newQuery) ->
    @_updateLocalState(['searchQuery'], newQuery)

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
