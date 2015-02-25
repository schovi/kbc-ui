
request = require '../../utils/request'
ApplicationStore = require '../../stores/ApplicationStore'
ComponentsStore = require '../components/stores/ComponentsStore'

createUrl = (componentId, path) ->
  ComponentsStore.getComponent(componentId).get('uri') + '/' + path

createRequest = (componentId, method, path) ->
  request(method, createUrl(componentId, path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())


module.exports =

  createRequest: createRequest