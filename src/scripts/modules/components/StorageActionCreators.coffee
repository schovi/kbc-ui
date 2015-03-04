Promise = require 'bluebird'
React = require 'react'
_ = require 'underscore'
Link = require('react-router').Link
console.log 'Link', Link


ApplicationActionCreators = require '../../actions/ApplicationActionCreators'

dispatcher = require '../../Dispatcher'
constants = require './Constants'
componentRunner = require './ComponentRunner'
StorageBucketsStore = require './stores/StorageBucketsStore'
StorageTablesStore = require './stores/StorageTablesStore'
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
    return Promise.resolve() if StorageTablesStore.getIsLoaded()
    @loadTablesForce()
