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

  loadBuckets: ->
    return Promise.resolve() if StorageBucketsStore.getIsLoaded()
    @loadBucketsForce()

  loadTablesForce: ->
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
