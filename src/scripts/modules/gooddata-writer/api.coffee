
SyrupApi = require '../components/SyrupComponentApi'

createRequest = (method, path) ->
  SyrupApi.createRequest('gooddata-writer', method, path)

module.exports =

  getWriters: ->
    createRequest('GET', "writers")
    .promise()
    .then((response) ->
      response.body
    )

  getWriter: (configurationId) ->
    createRequest('GET', "writers")
    .query writerId: configurationId
    .promise()
    .then((response) ->
      response.body.writer
    )

  getWriterTables: (configurationId) ->
    createRequest('GET', "tables")
    .query writerId: configurationId
    .promise()
    .then((response) ->
      response.body.tables
    )

