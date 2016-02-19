_ = require 'underscore'
{List} = require 'immutable'
moment = require 'moment'
index = require './react/pages/Index/Index'
tableDetail = require './react/pages/Table/Table'
destinationPage = require './react/pages/Destination/Destination'
tableEditButtons = require './react/components/TableHeaderButtons'
JobsActionCreators = require '../jobs/ActionCreators'
LatestJobsStore = require '../jobs/stores/LatestJobsStore'
installedComponentsActions = require '../components/InstalledComponentsActionCreators'
oauthStore = require '../components/stores/OAuthStore'
oauthActions = require '../components/OAuthActionCreators'

InstalledComponentsStore = require '../components/stores/InstalledComponentsStore'
ApplicationActionCreators = require('../../actions/ApplicationActionCreators')
storageActionCreators = require '../components/StorageActionCreators'
ComponentsStore = require '../components/stores/ComponentsStore'
RouterStore = require('../../stores/RoutesStore')
componentId = 'tde-exporter'
{fromJS} = require 'immutable'

# return first non empty(aka authorized) writer account
findNonEmptyAccount = (configData) ->
  for account in ['tableauServer', 'dropbox', 'gdrive']
    data = configData.getIn(['parameters', account])
    if not _.isEmpty(data?.toJS())
      return account
  return null

# load files from file uploads
loadFiles = (force) ->
  tags = ['tde', 'table-export']
  params = "q": _.map(tags, (t) -> "+tags:#{t}").join(' ')
  if force
    storageActionCreators.loadFilesForce(params)
  else
    storageActionCreators.loadFiles(params)

#reload files from files uploads if at least one job has finished up to 10 seconds ago
reloadSapiFilesTrigger = (jobs) ->
  tresholdTrigger = 20 #seconds of end time from now to reload all files
  for job in jobs
    if job.endTime
      endTime = moment(job.endTime)
      now = moment()
      diff = moment.duration(now.diff(endTime))
      if (diff < moment.duration(tresholdTrigger, 'seconds'))
        return loadFiles(true)


#migrate tasks that have and uploadTasks set but no stageTask
# setup first non empty authorized account if uploadTasks is empty
migrateUploadTasks = (configData, configId) ->

  uploadTasks = configData.getIn(['parameters', 'uploadTasks'], List())
  stageTask = configData.getIn(['parameters', 'stageUploadTask'])
  #migrate only if stageTask is not set
  if not stageTask
    newConfig = configData
    if uploadTasks.count() > 0
      console.log('migrating from uploadTasks')
      stageTask = uploadTasks.first()
      newConfig = configData.setIn ['parameters', 'stageUploadTask'], stageTask
      newConfig = configData
    else
      newTask = findNonEmptyAccount(configData)
      if newTask
        console.log('migrating from', newTask)
        newConfig = configData.setIn ['parameters', 'stageUploadTask'], newTask
    # if data has changed then update
    if newConfig != configData
      console.log('migrating upload tasks', configData?.toJS(), newConfig?.toJS())
      saveFn = installedComponentsActions.saveComponentConfigData
      saveFn(componentId, configId, newConfig)


module.exports =
  name: componentId
  path: ":config"
  defaultRouteHandler: index
  isComponent: true
  poll:
    interval: 7
    action: (params) ->
      JobsActionCreators.loadComponentConfigurationLatestJobs('tde-exporter', params.config).then ->
        jobs = LatestJobsStore.getJobs('tde-exporter', params.config)
        reloadSapiFilesTrigger(jobs.get('jobs')?.toJS())

  requireData: [
    (params) ->
      installedComponentsActions.loadComponentConfigData(componentId, params.config).then ->
        configData = InstalledComponentsStore.getConfigData(componentId, params.config)
        migrateUploadTasks(configData, params.config)
    ,
      ->
        storageActionCreators.loadTables()
      ->
        loadFiles(false)
  ]
  title: (routerState) ->
    configId = routerState.getIn ['params', 'config']
    InstalledComponentsStore.getConfig(componentId, configId).get('name')

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
    # requireData: [
    #   (params) ->

    #     gdriveActions.loadGoogleInfo(params.configId, googleId)
    # ]
    title: (routerState) ->
      return 'Setup Upload'
  ,
    name: 'tde-exporter-gdrive-redirect'
    path: 'oauth/gdrive'
    title: (routerState) ->
      return 'Google Drive Authorization verifying...'
    requireData: [
      (params) ->
        router =  RouterStore.getRouter()
        installedComponentsActions.loadComponentConfigData(componentId, params.config).then ->
          configuration = InstalledComponentsStore.getConfigData(componentId, params.config)
          query = router.getCurrentQuery()
          if query['access-token'] and query['refresh-token']
            email = query['email'] or 'unknown'
            gdrive =
              accessToken: query['access-token']
              refreshToken: query['refresh-token']
              targetFolder: null
              targetFolderName: ''
              email: email
            newConfig = configuration.setIn ['parameters', 'gdrive'], fromJS(gdrive)
            saveFn = installedComponentsActions.saveComponentConfigData
            saveFn(componentId, params.config, newConfig).then ->
              notification = "Google drive account #{email} succesfully authorized."
              ApplicationActionCreators.sendNotification
                message: notification
              router.transitionTo('tde-exporter-destination', config: params.config)
            .error (err) ->
              notification = 'Failed to authorize the Google Drive account, please contact us on support@keboola.com'
              ApplicationActionCreators.sendNotification
                message: notification
                type: 'error'
              router.transitionTo(componentId, config: params.config)
    ]
  ,
    name: 'tde-exporter-dropbox-redirect'
    path: 'oauth/dropbox'
    title: ->
      return 'Dropbox authorization verifying..'
    requireData: [
      (params) ->
        installedComponentsActions.loadComponentConfigData(componentId, params.config).then ->
          configuration = InstalledComponentsStore.getConfigData(componentId, params.config)
          credentialsId = "tde-exporter-#{params.config}"
          router = RouterStore.getRouter()
          oauthActions.loadCredentials('wr-dropbox', credentialsId).then ->
            credentials = oauthStore.getCredentials('wr-dropbox', credentialsId).toJS()
            description = credentials?.description
            dropboxAccount =
              description: description
              id: credentialsId
            saveFn = installedComponentsActions.saveComponentConfigData
            newConfig = configuration.setIn ['parameters', 'dropbox'], fromJS(dropboxAccount)
            saveFn(componentId, params.config, newConfig).then ->

              notification = "Dropbox account #{description} succesfully authorized."
              ApplicationActionCreators.sendNotification
                message: notification
              router.transitionTo('tde-exporter-destination', config: params.config)
          .error (err) ->
            notification = 'Failed to authorize the Dropbox account, please contact us on support@keboola.com'
            ApplicationActionCreators.sendNotification
              message: notification
              type: 'error'
            router.transitionTo('tde-exporter', config: params.config)



  ] #requiredata end

  ]
