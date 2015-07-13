React = require('react')
_ = require('underscore')
{Map} = require 'immutable'
ExGdriveStore = require '../../../exGdriveStore'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'

ActionCreators = require '../../../exGdriveActionCreators'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

RoutesStore = require '../../../../../stores/RoutesStore'
Picker = React.createFactory(require('../../../../google-utils/react/GooglePicker'))
ViewTemplates = require '../../../../google-utils/react/PickerViewTemplates'

{Panel, PanelGroup} = require('react-bootstrap')
Accordion = React.createFactory(require('react-bootstrap').Accordion)
PanelGroup = React.createFactory PanelGroup
GdriveFilePanel = React.createFactory(require('./GdriveFilePanel'))
ConfigSheetsPanels = React.createFactory(require('./ConfigSheetsPanels'))
TabbedArea = React.createFactory(require('react-bootstrap').TabbedArea)
TabPane = React.createFactory(require('react-bootstrap').TabPane)
SearchRow = React.createFactory(require('../../../../../react/common/SearchRow'))
Button = React.createFactory(require('react-bootstrap').Button)
Loader = React.createFactory(require('kbc-react-components').Loader)
{div, span} = React.DOM

module.exports = React.createClass
  name: 'SheetsPicker'
  mixins: [createStoreMixin(ExGdriveStore, InstalledComponentsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    localState = InstalledComponentsStore.getLocalState('ex-google-drive', configId)
    expandedSheets = localState.get('expandedSheets', Map())

    #state
    localState: localState
    expandedSheets: expandedSheets
    configId: configId
    files: ExGdriveStore.getGdriveFiles(configId)
    loadingFiles: ExGdriveStore.getLoadingFiles(configId)
    selectedSheets: ExGdriveStore.getSelectedSheets configId
    config: ExGdriveStore.getConfig(configId)
    searchQuery: ExGdriveStore.getSearchQueryValue(configId) or ''
    nextPageToken: ExGdriveStore.getNextPageToken(configId)
    isLoadingMore: ExGdriveStore.isLoadingMore(configId)
    isConfigLoaded: ExGdriveStore.hasConfig configId


  render: ->
    #console.log 'sheet picker files', @state.files.toJS()
    console.log 'DEVEL render'
    if @state.isConfigLoaded and @state.config
      div {className: 'container-fluid kbc-main-content'},
        div {className: 'table kbc-table-border-vertical kbc-detail-table'},
          div {className: 'tr'},
            div {className: 'td'},
              @_renderPicker()
              @_renderFilesPanel()
            div {className: 'td'},
              @_renderProjectConfigFiles()
    else
      div {}, 'Loading ...'

  _renderFilesPanel: ->
    if not filterFn
      filterFn = (file) ->
        file
    items = @state.config.get 'items'
    div className: '',
      React.DOM.h2 {}, "2. Select sheets from selected documents"
      SearchRow
        query: @state.searchQuery
        onChange: @_searchRowChanged
    ,

      GdriveFilePanel
        expandedSheets: @state.expandedSheets
        setExpandedSheetsFn: @_updateLocalState.bind(@, ['expandedSheets'])
        loadSheetsFn: @_loadFilesSheets
        selectSheetFn: @_selectSheet
        deselectSheetFn: @_deselectSheet
        selectedSheets: @state.selectedSheets
        configuredSheets: items
        loadingFiles: @state.loadingFiles
        files: @state.files.filter( (file) ->
          fileTitle = file.get('title').toLowerCase()
          containsQuery = fileTitle.toLowerCase().indexOf(@state.searchQuery)
          if @state.searchQuery == '' or containsQuery >= 0
            return filterFn(file)
          else
            return false
        , @)


  _renderPicker: ->
    div className: '',
      React.DOM.h2 {}, "1. Select documents of #{@state.config.get('email')}"
      Picker
        email: @state.config.get('email')
        dialogTitle: 'Select a spreadsheet document'
        buttonLabel: 'Select spreadsheet document from Google Drive...'
        onPickedFn: (data) =>
          data = _.filter data, (file) ->
            file.type == 'document'
          data = _.map data, (file) ->
            file.title = file.name
            file
          console.log "PICKED sheets", data
          ActionCreators.addMoreFiles(@state.configId, data)

        views: [
          ViewTemplates.sheets
          ViewTemplates.sharedSheets
          ViewTemplates.recent
        ]


  _searchRowChanged: (newValue) ->
    ActionCreators.searchQueryChange(@state.configId, newValue)

  _renderProjectConfigFiles: ->
    div className: '',
      ConfigSheetsPanels
        deselectSheetFn: @_deselectSheet
        selectedSheets: @state.selectedSheets
        configSheets: @state.config.get 'items'
        getPathFn: @_getPath

  _deselectSheet: (fileId, sheetId) ->
    ActionCreators.deselectSheet(@state.configId, fileId, sheetId)

  _selectSheet: (file, sheet) ->
    ActionCreators.selectSheet(@state.configId, file, sheet)

  _loadFilesSheets: (file) ->
    ActionCreators.loadGdriveFileSheets(@state.configId, file.get('id'))

  _isFileOwner: (file) ->
    if not file
      return true
    email = @state.config.get 'email'
    owners = file.get 'owners'
    result = owners?.filter (owner) ->
      owner.get('emailAddress') == email
    return result?.count() > 0

  _getPath: (fileId) ->
    return null

  _loadMore: ->
    ActionCreators.loadMoreFiles(@state.configId, @state.nextPageToken)

  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState('ex-google-drive', @state.configId, newLocalState)
