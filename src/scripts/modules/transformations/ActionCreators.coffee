

dispatcher = require '../../Dispatcher'
constants = require './Constants'
transformationsApi = require './TransformationsApi'
TransformationBucketsStore = require './stores/TransformationBucketsStore'
TransformationsStore = require './stores/TransformationBucketsStore'
Promise = require 'bluebird'


module.exports =

  ###
    Request orchestrations reload from server
  ###
  loadTransformationBucketsForce: ->
    actions = @

    # trigger load initialized
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_BUCKETS_LOAD
    )

    # init load
    transformationsApi
    .getTransformationBuckets()
    .then((buckets) ->
      # load success
      actions.receiveAllTransformationBuckets(buckets)
    )
    .catch (err) ->
      throw err

  receiveAllTransformationBuckets: (buckets) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_BUCKETS_LOAD_SUCCESS
      buckets: buckets
    )

  ###
    Request transformation buckets load only if not already loaded
    @return Promise
  ###
  loadTransformationBuckets: ->
    # don't load if already loaded
    return Promise.resolve() if TransformationBucketsStore.getIsLoaded()
    
    @.loadTransformationBucketsForce()

  ###
    Request specified orchestration load from server
    @return Promise
  ###
  loadTransformationsForce: (bucketId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATIONS_LOAD
      bucketId: bucketId
    )

    transformationsApi
    .getTransformations(bucketId)
    .then((transformations) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATIONS_LOAD_SUCCESS
        transformations: transformations
      )
      return
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATIONS_LOAD_ERROR
      )
      throw error
    )

  loadTransformations: (bucketId) ->
    return Promise.resolve() if TransformationsStore.has(bucketId)
    @loadTransformationsForce(bucketId)