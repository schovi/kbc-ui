
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

  getReferenceableTables: (configurationId) ->
    createRequest('GET', 'tables')
    .query writerId: configurationId
    .query connection: true
    .promise()
    .then (response) ->
      response.body.tables

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

  resetTable: (configurationId, tableId) ->
    createRequest('POST', 'reset-table')
    .send
      tableId: tableId
      writerId: configurationId
    .promise()
    .then (response) ->
      response.body

  uploadTable: (configurationId, tableId) ->
    createRequest('POST', 'upload-table')
    .send
      tableId: tableId
      writerId: configurationId
    .promise()
    .then (response) ->
      response.body

  uploadProject: (configurationId) ->
    createRequest('POST', 'upload-project')
    .send
      writerId: configurationId
    .promise()
    .then (response) ->
      response.body


  getDateDimensions: (configurationId) ->
    createRequest('GET', 'date-dimensions')
    .query writerId: configurationId
    .promise()
    .then (response) ->
      response.body.dimensions

  deleteDateDimension: (configurationId, name) ->
    createRequest('DELETE', 'date-dimensions')
    .query writerId: configurationId
    .query name: name
    .promise()
    .then (response) ->
      response.body

  createDateDimension: (configurationId, dateDimension) ->
    data = Immutable.fromJS(dateDimension)
    .set 'writerId', configurationId

    createRequest('POST', 'date-dimensions')
    .query writerId: configurationId
    .send data.toJS()
    .promise()
    .then (response) ->
      response.body
