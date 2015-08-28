_ = require 'underscore'

module.exports =

  isTableauServerAuthorized: (account) ->
    account and
      not _.isEmpty(account.get('server_url')) and
      not _.isEmpty(account.get('username')) and
      not _.isEmpty(account.get('password')) and
      not _.isEmpty(account.get('project_id'))

  isDropboxAuthorized: (account) ->
    account and
      account.has('description') and
      account.has('id')

  isGdriveAuthorized: (account) ->
    account and
      not _.isEmpty(account.get('accessToken')) and
      not _.isEmpty(account.get('refreshToken')) and
      not _.isEmpty(account.get('email'))

  prepareUploadRunParams: (componentId, account, tdeFile, configId) ->
    storage =
      input:
        files: [
          query: "id:#{tdeFile.get('id')}"
        ]
    parameters = account.toJS() # if component is tableau server
    if componentId == 'wr-dropbox'
      parameters =
        credentials: account.get('id')
        mode: true

    result = null
    if componentId in ['wr-dropbox', 'wr-tableau-server']
      result =
        configId: configId
        configData:
          storage: storage
          parameters: parameters
    else
      # if wr google drive
      result =
        external:
          account: account.toJS()
          query: "id:#{tdeFile.get('id')}"
          targetFolder: null #todo!!

    return result
