React = require('react')
ExGdriveStore = require '../../../exGdriveStore'
ActionCreators = require '../../../exGdriveActionCreators'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'

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
  mixins: [createStoreMixin(ExGdriveStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
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
    if @state.isConfigLoaded and @state.config
      div {className: 'container-fluid kbc-main-content'},
        @_renderGdriveFiles()
        @_renderProjectConfigFiles()
    else
      div {}, 'Loading ...'


  _searchRowChanged: (newValue) ->
    ActionCreators.searchQueryChange(@state.configId, newValue)

  _renderGdriveFiles: ->
    component = @
    div className: 'col-sm-6',
      SearchRow
        query: @state.searchQuery
        onChange: @_searchRowChanged
    ,
      TabbedArea defaultActiveKey: 'mydrive', animation: false,
        TabPane eventKey: 'mydrive', tab: 'My Drive',
          @_renderFilePanel (file) ->
            component._isFileOwner(file)
        TabPane eventKey: 'shared', tab: 'Shared With Me',
          @_renderFilePanel (file) ->
            not component._isFileOwner(file)
        TabPane eventKey: 'all', tab: 'All Sheets',
          @_renderFilePanel()
      if @state.nextPageToken
        Button
          className: 'btn btn-default'
          onClick: @_loadMore
          disabled: @state.isLoadingMore
        ,
          'Load more...'
          Loader() if @state.isLoadingMore


  _renderProjectConfigFiles: ->
    div className: 'col-sm-6',
      ConfigSheetsPanels
        deselectSheetFn: @_deselectSheet
        selectedSheets: @state.selectedSheets
        configSheets: @state.config.get 'items'
        getPathFn: @_getPath

  _renderFilePanel: (filterFn) ->
    if not filterFn
      filterFn = (file) ->
        file
    GdriveFilePanel
      loadSheetsFn: @_loadFilesSheets
      selectSheetFn: @_selectSheet
      deselectSheetFn: @_deselectSheet
      selectedSheets: @state.selectedSheets
      configuredSheets: @state.config.get 'items'
      loadingFiles: @state.loadingFiles
      files: @state.files.filter( (file) ->
        fileTitle = file.get('title').toLowerCase()
        containsQuery = fileTitle.toLowerCase().indexOf(@state.searchQuery)
        if @state.searchQuery == '' or containsQuery >= 0
          return filterFn(file)
        else
          return false
      , @)

  _deselectSheet: (fileId, sheetId) ->
    ActionCreators.deselectSheet(@state.configId, fileId, sheetId)

  _selectSheet: (file, sheet) ->
    ActionCreators.selectSheet(@state.configId, file, sheet)

  _loadFilesSheets: (file) ->
    ActionCreators.loadGdriveFileSheets(@state.configId, file.get('id'))

  _isFileOwner: (file) ->
    email = @state.config.get 'email'
    owners = file.get 'owners'
    result = owners.filter (owner) ->
      owner.get('emailAddress') == email
    return result.count() > 0

  _getPath: (fileId) ->
    file = @state.files.getIn [fileId]
    if file && @_isFileOwner(file)
      return 'My Drive'
    else
      return 'Shared With Me'
  _loadMore: ->
    ActionCreators.loadMoreFiles(@state.configId, @state.nextPageToken)
