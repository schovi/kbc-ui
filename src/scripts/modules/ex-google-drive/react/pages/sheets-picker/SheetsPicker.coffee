React = require('react')
ExGdriveStore = require '../../../exGdriveStore.coffee'
ActionCreators = require '../../../exGdriveActionCreators.coffee'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

{Panel, PanelGroup} = require('react-bootstrap')
Accordion = React.createFactory(require('react-bootstrap').Accordion)
PanelGroup = React.createFactory PanelGroup
GdriveFilePanel = React.createFactory(require('./GdriveFilePanel.coffee'))
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

  render: ->
    #console.log 'sheet picker files', @state.files.toJS()
    div {className: 'container-fluid kbc-main-content'},
      @_renderGdriveFiles()
      @_renderProjectConfigFiles()

  _renderGdriveFiles: ->
    div className: 'col-sm-6',
      GdriveFilePanel
        files: @state.files
        loadSheetsFn: @_loadFilesSheets
        loadingFiles: @state.loadingFiles
        selectSheetFn: @_selectSheet
        selectedSheets: @state.selectedSheets
        deselectSheetFn: @_deselectSheet

  _deselectSheet: (fileId, sheetId) ->
    ActionCreators.deselectSheet(@state.configId, fileId, sheetId)

  _selectSheet: (file, sheet) ->
    ActionCreators.selectSheet(@state.configId, file, sheet)

  _loadFilesSheets: (file) ->
    ActionCreators.loadGdriveFileSheets(@state.configId, file.get('id'))

  _renderProjectConfigFiles: ->
    div className: 'col-sm-6',
      span {}, 'project config files'
