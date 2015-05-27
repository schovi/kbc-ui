dispatcher = require '../../Dispatcher'
Constants = require('./exGanalConstants')
Promise = require('bluebird')
exGanalApi = require './exGanalApi'
exGanalStore = require './exGanalStore'
ApplicationActionCreators = require '../../actions/ApplicationActionCreators'
module.exports =

  sendLinkEmail: (emailObject, configId) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_SEND_LINK
      configId: configId
      emailObject: emailObject
    exGanalApi.sendLinkEmail(emailObject).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_SEND_LINK_SUCCESS
        configId: configId
      ApplicationActionCreators.sendNotification "Email has been succesfully sent to #{emailObject.email}"
    .catch (err) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_API_ERROR
        errorPath: ['sendingLink', configId]
        error: err
      throw err

  deleteQuery: (configId, queryName) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_DELETE_QUERY
      configId: configId
      queryName: queryName
    queries = exGanalStore.getDeletingQueries configId, queryName
    exGanalApi.postConfig(configId, queries.toJS()).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_DELETE_QUERY_SUCCESS
        configId: configId
        queryName: queryName
        newQueries: result
    .catch (err) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_API_ERROR
        errorPath: ['deletingQueries', configId, queryName]
        error: err
      throw err

  saveOutputBucket: (configId, newBucket) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_OUTBUCKET_SAVE
      configId: configId
      newBucket: newBucket
    exGanalApi.postOutputBucket(configId, newBucket).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_OUTBUCKET_SAVE_SUCCESS
        configId: configId
    .catch (err) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_API_ERROR
        errorPath: ['savingBucket', configId]
        error: err
      throw err

  saveSelectedProfiles: (configId) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_SELECT_PROFILE_SAVE
      configId: configId
    profiles = exGanalStore.getSavingProfiles configId
    profiles = profiles.map (profile, key) ->
      googleId: profile.get 'id'
      accountId: profile.get 'accountId'
      webPropertyId: profile.get 'webPropertyId'
      name: profile.get 'name'
      accountName: profile.get 'accountName'
      webPropertyName: profile.get 'webPropertyName'
    exGanalApi.postProfiles(configId, profiles.toJS()).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_SELECT_PROFILE_SAVE_SUCCESS
        configId: configId
    .catch (err) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_API_ERROR
        errorPath: ['savingProfiles', configId]
        error: err
      throw err

  cancelSelectedProfiles: (configId) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_SELECT_PROFILE_CANCEL
      configId: configId

  selectProfile: (configId, profile) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_SELECT_PROFILE
      configId: configId
      profile: profile

  deselectProfile: (configId, profile) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_DESELECT_PROFILE
      configId: configId
      profile: profile

  loadProfiles: (configId) ->
    if exGanalStore.hasProfiles(configId)
      return Promise.resolve()
    @loadProfilesForce(configId)


  loadProfilesForce: (configId) ->
    exGanalApi.getProfiles(configId).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_PROFILES_LOAD_SUCCESS
        configId: configId
        profiles: result


  generateExternalLink: (configId) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_GENERATE_EXT_LINK_START
      configId: configId
    exGanalApi.getExtLink(configId).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_GENERATE_EXT_LINK_END
        configId: configId
        extLink: result
    .catch (err) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_API_ERROR
        errorPath: ['extLinksGenerating', configId]
        error: err
      throw err
  loadConfiguration: (configId) ->
    if exGanalStore.hasConfig(configId)
      return Promise.resolve()
    @loadConfigurationForce(configId)

  loadConfigurationForce: (configId) ->
    exGanalApi.getConfig(configId).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_CONFIGURATION_LOAD_SUCCEES
        configId: configId
        data: result

  toogleEditing: (configId, name, initQuery) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_QUERY_TOOGLE_EDITING
      configId: configId
      initQuery: initQuery
      name: name

  saveQuery: (configId, name) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_QUERY_SAVE_START
      configId: configId
      name: name
    config = exGanalStore.getConfigToSave(configId)
    exGanalApi.postConfig(configId, config.toJS()).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_QUERY_SAVE_SUCCESS
        configId: configId
        name: name
        newConfig: result
    .catch (err) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_API_ERROR
        errorPath: ['savingConfig', configId]
        error: err
      throw err

  resetQuery: (configId, name) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_QUERY_RESET
      configId: configId
      name: name

  changeQuery: (configId, name, newQuery) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_CHANGE_QUERY
      configId: configId
      newQuery: newQuery
      name: name

  changeNewQuery: (configId, newQuery) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_CHANGE_NEW_QUERY
      configId: configId
      newQuery: newQuery

  resetNewQuery: (configId) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_NEW_QUERY_RESET
      configId: configId

  createQuery: (configId) ->
    dispatcher.handleViewAction
      type: Constants.ActionTypes.EX_GANAL_NEW_QUERY_CREATE_START
      configId: configId
    config = exGanalStore.getConfigToSave(configId)
    exGanalApi.postConfig(configId, config.toJS()).then (result) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_NEW_QUERY_CREATE_SUCCESS
        configId: configId
        newConfig: result
    .catch (err) ->
      dispatcher.handleViewAction
        type: Constants.ActionTypes.EX_GANAL_API_ERROR
        errorPath: ['savingConfig', configId]
        error: err
      throw err
