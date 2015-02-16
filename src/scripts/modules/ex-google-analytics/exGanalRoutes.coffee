IntalledComponentsStore = require '../components/stores/InstalledComponentsStore'

ExGanalIndex = require './react/pages/index/Index'
#ExGanalActionCreators = require './exGanalActionCreators'
#authorizePage = require './react/pages/authorize/authorize'
#ExGanalSheetHeaderButtons = require './react/components/SheetHeaderButtons'


module.exports =
  name: 'ex-google-analytics'
  path: 'ex-google-analytics/:config'
  defaultRouteHandler: ExGanalIndex
  # requireData: [
  #   (params) ->
  #     ExGoogleDriveActionCreators.loadConfiguration params.config
  # ]

  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    'Google Analytics extractor - ' + IntalledComponentsStore.getConfig('ex-google-analytics', configId).get 'name'
