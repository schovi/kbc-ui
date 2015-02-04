IntalledComponentsStore = require '../components/stores/InstalledComponentsStore.coffee'

ExGdriveIndex = require './react/pages/index/Index.coffee'
ExGoogleDriveActionCreators = require './exGdriveActionCreators.coffee'
sheetDetail = require './react/pages/sheet-detail/SheetDetail.coffee'
authorizePage = require './react/pages/authorize/authorize.coffee'
ExGdriveSheetHeaderButtons = require './react/components/SheetHeaderButtons.coffee'

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
    name: 'ex-google-drive-add-sheet'
    path: 'add-sheet'
  ,
    name: 'ex-google-drive-authorize'
    path: 'authorize'
    handler: authorizePage
  ,
    name: 'ex-google-drive-sheet'
    path: 'sheet/:fileId/:sheetId'
    title: ->
      'sheet'
    handler: sheetDetail
    headerButtonsHandler: ExGdriveSheetHeaderButtons

  ]
