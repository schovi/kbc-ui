_ = require 'underscore'
index = require './react/pages/Index/Index'
tableDetail = require './react/pages/Table/Table'
destinationPage = require './react/pages/Destination/Destination'
tableEditButtons = require './react/components/TableHeaderButtons'
JobsActionCreators = require '../jobs/ActionCreators'
installedComponentsActions = require '../components/InstalledComponentsActionCreators'
InstalledComponentsStore = require '../components/stores/InstalledComponentsStore'
ApplicationActionCreators = require('../../actions/ApplicationActionCreators')
storageActionCreators = require '../components/StorageActionCreators'
ComponentsStore = require '../components/stores/ComponentsStore'
RouterStore = require('../../stores/RoutesStore')
componentId = 'tde-exporter'
{fromJS} = require 'immutable'

module.exports =
  name: componentId
  path: "#{componentId}/:config"
  defaultRouteHandler: index
  isComponent: true
  poll:
    interval: 7
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs('tde-exporter', params.config)

  requireData: [
    (params) ->
      installedComponentsActions.loadComponentConfigData componentId, params.config
    ,
      ->
        storageActionCreators.loadTables()
      ->
        tags = ['tde', 'table-export']
        params = "q": _.map(tags, (t) -> "+tags:#{t}").join(' ')
        console.log "loaaad files", params
        storageActionCreators.loadFiles(params)
  ]
  title: (routerState) ->
    component = ComponentsStore.getComponent componentId
    configId = routerState.getIn ['params', 'config']
    componentName = component.get 'name'
    configName = InstalledComponentsStore.getConfig(componentId, configId).get('name')
    return "#{componentName} - #{configName}"

  childRoutes: [
    #isComponent: true
    name: "tde-exporter-table"
    path: 'table/:tableId'
    handler: tableDetail
    headerButtonsHandler: tableEditButtons
    title: (routerState) ->
      tableId = routerState.getIn ['params', 'tableId']
      return tableId
  ,
    name: 'tde-exporter-destination'
    path: 'destination'
    handler: destinationPage
    title: (routerState) ->
      return 'Destination Setup'
  ,
    name: 'tde-exporter-gdrive-redirect'
    path: 'oauth/gdrive'
    title: (routerState) ->
      return 'Google Drive Redirect'
    requireData: [
      (params) ->
        installedComponentsActions.loadComponentConfigData(componentId, params.config).then ->
          configuration = InstalledComponentsStore.getConfigData(componentId, params.config)

          router =  RouterStore.getRouter()
          query = router.getCurrentQuery()
          console.log "configuration", configuration?.toJS()
          if query['access-token'] and query['refresh-token']
            console.log "AUTHORIZED"
            email = query['email'] or 'unknown'
            gdrive =
              accessToken: query['access-token']
              refreshToken: query['refresh-token']
              targetFolder: null
              targetFolderName: ''
              email: email
            newConfig = configuration.setIn ['parameters', 'gdrive'], gdrive
            saveFn = installedComponentsActions.saveComponentConfigData
            saveFn(componentId, params.config, fromJS(newConfig)).then ->
              notification = "Google drive account #{email} succesfully authorized."
              ApplicationActionCreators.sendNotification
                message: notification
              router.transitionTo('tde-exporter-destination', config: params.config)
            , (err) ->
              notification = 'Failed to authorize the Google Drive account, please contact us on support@keboola.com'
              ApplicationActionCreators.sendNotification
                message: notification
                type: 'error'
              router.transitionTo(componentId, config: params.config)





    ]
  ]
