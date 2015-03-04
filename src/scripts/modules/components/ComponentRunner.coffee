
ComponentsStore = require './stores/ComponentsStore'
ApplicationStore = require '../../stores/ApplicationStore'

request = require '../../utils/request'

_getComponentUrl = (componentId) ->
  component = ComponentsStore.getComponent(componentId)
  if !component
    throw "Component '#{componentId}' not found."
  component.get 'uri'

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

