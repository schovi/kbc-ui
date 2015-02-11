IntalledComponentsStore = require '../components/stores/InstalledComponentsStore.coffee'

#ExGanalIndex = require './react/pages/index/Index.coffee'
#ExGanalActionCreators = require './exGanalActionCreators.coffee'
#authorizePage = require './react/pages/authorize/authorize.coffee'
#ExGanalSheetHeaderButtons = require './react/components/SheetHeaderButtons.coffee'


module.exports =
  name: 'ex-google-analytics'
  path: 'ex-google-analytics/:config'
  #defaultRouteHandler: ExGdriveIndex
  # requireData: [
  #   (params) ->
  #     ExGoogleDriveActionCreators.loadConfiguration params.config
  # ]

  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    'Google Analytics extractor - ' + IntalledComponentsStore.getConfig('ex-google-analytics', configId).get 'name'
