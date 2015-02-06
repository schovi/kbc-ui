React = require('react')
ExGdriveStore = require '../../../exGdriveStore.coffee'
ActionCreators = require '../../../exGdriveActionCreators.coffee'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

{Panel, PanelGroup} = require('react-bootstrap')
Accordion = React.createFactory(require('react-bootstrap').Accordion)
PanelGroup = React.createFactory PanelGroup
GdriveFilePanel = React.createFactory(require('./GdriveFilePanel.coffee'))
TabbedArea = React.createFactory(require('react-bootstrap').TabbedArea)
TabPane = React.createFactory(require('react-bootstrap').TabPane)

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


  render: ->
    console.log 'sheet picker files', @state.files.toJS()
    div {className: 'container-fluid kbc-main-content'},
      @_renderGdriveFiles()
      @_renderProjectConfigFiles()

  _renderFilePanel: (filterFn) ->
    if not filterFn
      filterFn = (file) ->
        file
    GdriveFilePanel
      loadSheetsFn: @_loadFilesSheets
      selectSheetFn: @_selectSheet
      deselectSheetFn: @_deselectSheet
      selectedSheets: @state.selectedSheets
      loadingFiles: @state.loadingFiles
      files: @state.files.filter( (file) ->
        filterFn(file))

  _isFileOwner: (file) ->
    email = @state.config.get 'email'
    owners = file.get 'owners'
    result = owners.filter (owner) ->
      owner.get('emailAddress') == email
    return result.count() > 0

  _renderGdriveFiles: ->
    div className: 'col-sm-6',
      TabbedArea defaultActiveKey: 'mydrive', animation: false,
        TabPane eventKey: 'mydrive', tab: 'My Drive',
          @_renderFilePanel (file) =>
            @_isFileOwner(file)
        TabPane eventKey: 'shared', tab: 'Shared with me',
          @_renderFilePanel (file) =>
            not @_isFileOwner(file)
        TabPane eventKey: 'all', tab: 'All Sheets',
          @_renderFilePanel()

  _deselectSheet: (fileId, sheetId) ->
    ActionCreators.deselectSheet(@state.configId, fileId, sheetId)

  _selectSheet: (file, sheet) ->
    ActionCreators.selectSheet(@state.configId, file, sheet)

  _loadFilesSheets: (file) ->
    ActionCreators.loadGdriveFileSheets(@state.configId, file.get('id'))

  _renderProjectConfigFiles: ->
    div className: 'col-sm-6',
      span {}, 'project config files'
