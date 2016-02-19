Promise = require 'bluebird'
React = require 'react'
_ = require 'underscore'
Link = require('react-router').Link


ApplicationActionCreators = require '../../actions/ApplicationActionCreators'

dispatcher = require '../../Dispatcher'
constants = require './Constants'
componentRunner = require './ComponentRunner'
StorageBucketsStore = require './stores/StorageBucketsStore'
StorageTablesStore = require './stores/StorageTablesStore'
StorageTokensStore = require './stores/StorageTokensStore'
StorageFilesStore = require './stores/StorageFilesStore'
storageApi = require './StorageApi'

module.exports =

  loadBucketsForce: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.STORAGE_BUCKETS_LOAD
    )

    storageApi
    .getBuckets()
    .then((buckets) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.STORAGE_BUCKETS_LOAD_SUCCESS
        buckets: buckets
      )
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.STORAGE_BUCKETS_LOAD_ERROR
        status: error.status
        response: error.response
      )
      throw error
    )

  loadCredentialsForce: (bucketId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_LOAD
      bucketId: bucketId
    )
    storageApi
    .getBucketCredentials(bucketId)
    .then((credentials) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_LOAD_SUCCESS
        credentials: credentials
        bucketId: bucketId
      )
    )

  loadCredentials: (bucketId) ->
    return Promise.resolve() if StorageBucketsStore.hasCredentials(bucketId)
    @loadCredentialsForce(bucketId)

  createCredentials: (bucketId, name) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_CREATE
      bucketId: bucketId
    )
    storageApi
    .createBucketCredentials(bucketId, name)
    .then((credentials) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_CREATE_SUCCESS
        credentials: credentials
        bucketId: bucketId
      )
      credentials
    )

  deleteCredentials: (bucketId, credentialsId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_DELETE
      bucketId: bucketId
      credentialsId: credentialsId
    )
    storageApi
    .deleteBucketCredentials(credentialsId)
    .then( ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_DELETE_SUCCESS
        bucketId: bucketId
        credentialsId: credentialsId
      )
    )


  loadBuckets: ->
    return Promise.resolve() if StorageBucketsStore.getIsLoaded()
    @loadBucketsForce()

  loadTablesForce: ->
    return Promise.resolve() if StorageTablesStore.getIsLoading()
    dispatcher.handleViewAction(
      type: constants.ActionTypes.STORAGE_TABLES_LOAD
    )

    storageApi
    .getTables()
    .then((tables) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.STORAGE_TABLES_LOAD_SUCCESS
        tables: tables
      )
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.STORAGE_TABLES_LOAD_ERROR
        status: error.status
        response: error.response
      )
      throw error
    )

  loadTables: ->
    return Promise.resolve() if StorageTablesStore.getIsLoaded() or StorageTablesStore.getIsLoading()
    @loadTablesForce()

  loadTokensForce: ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.STORAGE_TOKENS_LOAD
    storageApi
    .getTokens()
    .then (tokens) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.STORAGE_TOKENS_LOAD_SUCCESS
        tokens: tokens
    .catch (error) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.STORAGE_TOKENS_LOAD_ERROR
        errors: error
      throw error

  loadTokens: ->
    return Promise.resolve() if StorageTokensStore.getIsLoaded()
    @loadTokensForce()

  createToken: (params) ->
    storageApi
    .createToken(params)
    .then((token) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.STORAGE_TOKEN_CREATE_SUCCESS
        token: token
      )
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.STORAGE_TOKEN_CREATE_ERROR
        status: error.status
        response: error.response
      )
      throw error
    )



  loadFilesForce: (params) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.STORAGE_FILES_LOAD
    storageApi
    .getFiles(params)
    .then (files) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.STORAGE_FILES_LOAD_SUCCESS
        files: files
    .catch (error) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.STORAGE_FILES_LOAD_ERROR
        errors: error
      throw error

  loadFiles: (params) ->
    return Promise.resolve() if StorageFilesStore.getIsLoaded()
    @loadFilesForce(params)
