IntalledComponentsStore = require '../components/stores/InstalledComponentsStore.coffee'

ExGdriveIndex = require './react/pages/index/Index.coffee'
ExGoogleDriveActionCreators = require './exGdriveActionCreators.coffee'
sheetDetail = require './react/pages/sheet-detail/SheetDetail.coffee'
authorizePage = require './react/pages/authorize/authorize.coffee'
ExGdriveSheetHeaderButtons = require './react/components/SheetHeaderButtons.coffee'
sheetsPicker = require './react/pages/sheets-picker/SheetsPicker.coffee'

module.exports =
  name: 'ex-google-drive'
  path: 'ex-google-drive/:config'
  defaultRouteHandler: ExGdriveIndex
  requireData: [
    (params) ->
      ExGoogleDriveActionCreators.loadConfiguration params.config
  ]

  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    'Google Drive extractor - ' + IntalledComponentsStore.getConfig('ex-google-drive', configId).get 'name'

  childRoutes: [
    name: 'ex-google-drive-select-sheets'
    path: 'sheets'
    handler: sheetsPicker
    title: 'Select Sheets'
    requireData: [
      (params) ->
        nextPageToken = "" #load first page
        ExGoogleDriveActionCreators.loadGdriveFiles(params.config, nextPageToken)
    ]
  ,
    name: 'ex-google-drive-authorize'
    path: 'authorize'
    handler: authorizePage
    title: 'Authorize Google Drive account'
  ,
    name: 'ex-google-drive-sheet'
    path: 'sheet/:fileId/:sheetId'
    title: ->
      'sheet'
    handler: sheetDetail
    headerButtonsHandler: ExGdriveSheetHeaderButtons

  ]
