React = require 'react'
{fromJS, Map, List} = require('immutable')
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
classnames = require 'classnames'
{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'

ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)

InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
TablesByBucketsPanel = React.createFactory require('../../components/TablesByBucketsPanel')
TableRow = React.createFactory require('./TableRow')
AuthorizeModal = React.createFactory require('./AuthorizeModal')
OptionsModal = React.createFactory require('./OptionsModal')
ComponentMetadata = require '../../../../components/react/components/ComponentMetadata'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))

ActivateDeactivateButton = React.createFactory(ActivateDeactivateButton)
{ul, li, span, button, strong, div, i} = React.DOM

componentId = 'wr-dropbox'

module.exports = React.createClass
  displayName: 'wrDropboxIndex'
  mixins: [createStoreMixin(InstalledComponentsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    configData = InstalledComponentsStore.getConfigData(componentId, configId)
    localState = InstalledComponentsStore.getLocalState(componentId, configId)
    toggles = localState.get('bucketToggles', Map())
    savingData = InstalledComponentsStore.getSavingConfigData(componentId, configId)
    console.log "get state CONFIG DATA", configData.toJS()

    # state
    configId: configId
    configData: configData
    localState: localState
    bucketToggles: toggles
    savingData: savingData or Map()

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
      div className: 'row',
        TablesByBucketsPanel
          renderTableRowFn: @_renderTableRow
          renderHeaderRowFn: @_renderHeaderRow
          filterFn: @_filterBuckets
          onSearchQueryChange: @_handleSearchQueryChange
          searchQuery: @state.localState.get('searchQuery') or ''
          isTableExportedFn: @_isTableExported
          onToggleBucketFn: @_handleToggleBucket
          isBucketToggledFn: @_isBucketToggled


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
    configurationData:
      storage:
        input:
          tables: [source: tableId, destination: tableId]
      parameters: @state.configData.get('parameters', Map()).toJS()



  _isPendingTable: (tableId) ->
    result = @state.savingData.has('storage')
    console.log "is pending", result
    result


  _renderHeaderRow: ->
    div className: 'tr',
      span className: 'th',
        strong null, 'Table name'
    return null


  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      div className: 'kbc-buttons kbc-text-light',
        React.createElement ComponentMetadata,
          componentId: componentId
          configId: @state.configId
      ul className: 'nav nav-stacked',
        li {className: classnames(disabled: !@_getInputTables().count())},
          RunButtonModal
            title: 'Run Bulk Upload'
            mode: 'link'
            component: 'wr-dropbox'
            disabled: !@_getInputTables().count()
            disabledReason: "No tables configured."
            runParams: =>
              config: @state.configId
          ,
           "You are about to run upload of #{@_getInputTables().count()} selected table(s) to dropbox account"

        li null,
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
