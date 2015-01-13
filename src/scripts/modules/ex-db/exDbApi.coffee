
request = require '../../utils/request.coffee'
ApplicationStore = require '../../stores/ApplicationStore.coffee'
ComponentsStore = require '../components/stores/ComponentsStore.coffee'

createUrl = (path) ->
  ComponentsStore.getComponent('ex-db').get('uri') + '/' + path

createRequest = (method, path) ->
  request(method, createUrl(path))
  .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString())


module.exports =

  getQueries: (configurationId) ->
    createRequest('GET', "configs/#{configurationId}/queries")
    .promise()
    .then((response) ->
      response.body
    )

  getCredentials: (configurationId) ->
    createRequest('GET', "configs/#{configurationId}/credentials")
    .promise()
    .then((response) ->
      response.body
    )

  saveQuery: (configurationId, query) ->
    createRequest('PUT', "configs/#{configurationId}/queries/#{query.id}")
    .send(query)
    .promise()
    .then((response) ->
      response.body
    )

  deleteQuery: (configurationId, queryId) ->
    createRequest('DELETE', "configs/#{configurationId}/queries/#{queryId}")
    .promise()
    .then((response) ->
      response.body
    )

  createQuery: (configurationId, newQuery) ->
    createRequest('POST', "configs/#{configurationId}/queries")
    .send(newQuery)
    .promise()
    .then((response) ->
      response.body
    )
