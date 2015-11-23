
SyrupApi = require '../components/SyrupComponentApi'
Immutable = require 'immutable'
ApplicationStore = require '../../stores/ApplicationStore'

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
    createRequest('GET', "v2/" + configurationId + "?include=project,project.ssoLink")
    .promise()
    .then((response) ->
      response.body
    )

  getWriterModel: (configurationId) ->
    createRequest('GET', 'model')
    .query config: configurationId
    .promise()
    .then (response) ->
      response.body

  getWriterTables: (configurationId) ->
    createRequest('GET', "tables")
    .query config: configurationId
    .promise()
    .then((response) ->
      response.body.tables
    )

  getTableDetail: (configurationId, tableId) ->
    createRequest('GET', 'tables')
    .query config: configurationId
    .query tableId: tableId
    .promise()
    .then (response) ->
      response.body.table

  getReferenceableTables: (configurationId) ->
    createRequest('GET', 'tables')
    .query config: configurationId
    .query connection: true
    .promise()
    .then (response) ->
      response.body.tables

  updateTable: (configurationId, tableId, data) ->
    data = Immutable.fromJS(data)
      .set 'config', configurationId
      .set 'tableId', tableId

    createRequest('POST', 'tables')
    .query config: configurationId
    .send data.toJS()
    .promise()
    .then (response) ->
      response.body

  resetTable: (configurationId, tableId) ->
    createRequest('POST', 'reset-table')
    .send
      tableId: tableId
      config: configurationId
    .promise()
    .then (response) ->
      response.body

  synchronizeTable: (configurationId, tableId) ->
    createRequest('POST', 'sync-datasets')
    .send
      tables: [tableId]
      config: configurationId
    .promise()
    .then (response) ->
      response.body

  uploadTable: (configurationId, tableId) ->
    createRequest('POST', 'upload-table')
    .send
      tableId: tableId
      config: configurationId
    .promise()
    .then (response) ->
      response.body

  uploadDateDimension: (configurationId, dimensionName) ->
    createRequest('POST', 'upload-date-dimension')
    .send
      name: dimensionName
      config: configurationId
    .promise()
    .then (response) ->
      response.body

  uploadProject: (configurationId) ->
    createRequest('POST', 'upload-project')
    .send
      config: configurationId
    .promise()
    .then (response) ->
      response.body

  optimizeSLIHash: (configurationId) ->
    createRequest('POST', 'optimize-sli-hash')
    .send
      config: configurationId
    .promise()
    .then (response) ->
      response.body

  resetProject: (configurationId) ->
    createRequest('POST', 'reset-project')
    .send
      config: configurationId
    .promise()
    .then (response) ->
      response.body

  deleteWriter: (configurationId) ->
    createRequest('DELETE', 'writers')
    .query config: configurationId
    .promise()
    .then (response) ->
      response.body

  getDateDimensions: (configurationId) ->
    createRequest('GET', 'date-dimensions')
    .query config: configurationId
    .promise()
    .then (response) ->
      response.body.dimensions

  deleteDateDimension: (configurationId, name) ->
    createRequest('DELETE', 'date-dimensions')
    .query config: configurationId
    .query name: name
    .promise()
    .then (response) ->
      response.body

  createDateDimension: (configurationId, dateDimension) ->
    data = Immutable.fromJS(dateDimension)
    .set 'config', configurationId

    createRequest('POST', 'date-dimensions')
    .query config: configurationId
    .send data.toJS()
    .promise()
    .then (response) ->
      response.body


  enableProjectAccess: (configurationId, pid) ->
    createRequest('POST', "v2/" + configurationId + "/projects/" + pid + "/access")
    .promise()
    .then((response) ->
      response.body
    )

  disableProjectAccess: (configurationId, pid) ->
    createRequest('DELETE', "v2/" + configurationId + "/projects/" + pid + "/access")
    .promise()
    .then((response) ->
      response.body
    )