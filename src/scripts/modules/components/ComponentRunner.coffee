
ComponentsStore = require './stores/ComponentsStore.coffee'
ApplicationStore = require '../../stores/ApplicationStore.coffee'

request = require '../../utils/request.coffee'

_getComponentUrl = (componentId) ->
  ComponentsStore.getComponent(componentId).get 'uri'

module.exports =

  ###
  params:
  component: id of component
  data: run parameters
  method: run method
  ###
  run: (params) ->

    request('POST', _getComponentUrl(params.component) + '/' + params.method)
    .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())
    .send params.data
      .promise()
      .then (response) ->
        response.body

