IndexPage = require './react/pages/index/Index'

module.exports =
  name: 'wr-dropbox'
  path: 'wr-dropbox/:config'
  isComponent: true
  # requireData: [
  #   (params) ->
  #     actionCreators.loadConfiguration params.config
  # ]
  title: (routerState) ->
    "Dropbox Writer"
    # configId = routerState.getIn ['params', 'config']
    # 'GoodData - ' + InstalledComponentsStore.getConfig('gooddata-writer', configId).get 'name'
  defaultRouteHandler: IndexPage
