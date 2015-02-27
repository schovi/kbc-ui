
SyrupApi = require '../components/SyrupComponentApi'
Immutable = require 'immutable'

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

  getTableDetail: (configurationId, tableId) ->
    createRequest('GET', 'tables')
    .query writerId: configurationId
    .query tableId: tableId
    .promise()
    .then (response) ->
      response.body.table

  updateTable: (configurationId, tableId, data) ->
    data = Immutable.fromJS(data)
      .set 'writerId', configurationId
      .set 'tableId', tableId

    createRequest('POST', 'tables')
    .query writerId: configurationId
    .send data.toJS()
    .promise()
    .then (response) ->
      response.body


