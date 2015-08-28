_ = require 'underscore'

storageInputFileTemplate = (fileId) ->
  storage =
      input:
        files: [
          query: "id:#{fileId}"
        ]
  return storage

module.exports =

  componentGetRunJson:
    'wr-google-drive': (parameters) ->
      account = parameters.get 'gdrive'
      result =
        external:
          account: account.toJS()
          query: "id:#{tdeFile.get('id')}"
          targetFolder: null #todo!!

    'wr-dropbox': (parameters, tdeFile, configId) ->
      storage = storageInputFileTemplate(tdeFile.get('id'))
      account = parameters.get 'dropbox'
      runParameters =
        credentials: account.get('id')
        mode: true
      result =
        config: configId
        configData:
          storage: storage
          parameters: runParameters
      return result

    'wr-tableau-server': (parameters, tdeFile, configId) ->
      storage = storageInputFileTemplate(tdeFile.get('id'))
      credentials = parameters.get 'tableauServer'
      result =
        config: configId
        configData:
          storage: storage
          parameters: credentials.toJS()
      return result


  isTableauServerAuthorized: (parameters) ->
    account = parameters.get('tableauServer')
    account and
      not _.isEmpty(account.get('server_url')) and
      not _.isEmpty(account.get('username')) and
      not _.isEmpty(account.get('password')) and
      not _.isEmpty(account.get('project_id'))

  isDropboxAuthorized: (parameters) ->
    account = parameters.get('dropbox')
    account and
      account.has('description') and
      account.has('id')

  isGdriveAuthorized: (parameters) ->
    account = parameters.get('gdrive')
    account and
      not _.isEmpty(account.get('accessToken')) and
      not _.isEmpty(account.get('refreshToken')) and
      not _.isEmpty(account.get('email'))

  prepareUploadRunParams: (componentId, parameters, tdeFile, configId) ->
    return @componentGetRunJson[componentId](parameters, tdeFile, configId)
