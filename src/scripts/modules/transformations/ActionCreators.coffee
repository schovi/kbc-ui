dispatcher = require '../../Dispatcher'
constants = require './Constants'
transformationsApi = require './TransformationsApi'
TransformationBucketsStore = require './stores/TransformationBucketsStore'
TransformationsStore = require './stores/TransformationsStore'
InstalledComponentsActionCreators = require '../components/InstalledComponentsActionCreators'
Promise = require 'bluebird'
_ = require 'underscore'

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


  createTransformationBucket: (data) ->
    newBucket = {}
    transformationsApi
    .createTransformationBucket(data)
    .then((bucket) ->
      newBucket = bucket
      InstalledComponentsActionCreators.loadComponentsForce()
    )
    .then( ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_BUCKET_CREATE_SUCCESS
        bucket: newBucket
      )
    )


  deleteTransformationBucket: (bucketId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.TRANSFORMATION_BUCKET_DELETE
      bucketId: bucketId

    transformationsApi
    .deleteTransformationBucket(bucketId)
    .then ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.TRANSFORMATION_BUCKET_DELETE_SUCCESS
        bucketId: bucketId
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.TRANSFORMATION_BUCKET_DELETE_ERROR
        bucketId: bucketId
      throw e

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
        bucketId: bucketId
      )
      return
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATIONS_LOAD_ERROR
        bucketId: bucketId
      )
      throw error
    )

  loadTransformations: (bucketId) ->
    return Promise.resolve() if TransformationsStore.hasTransformations bucketId
    @loadTransformationsForce(bucketId)


  deleteTransformation: (bucketId, transformationId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_DELETE
      bucketId: bucketId
      transformationId: transformationId
    )

    transformationsApi
    .deleteTransformation(bucketId, transformationId)
    .then( ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_DELETE_SUCCESS
        transformationId: transformationId
        bucketId: bucketId
      )
      return
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_DELETE_ERROR
        transformationId: transformationId
        bucketId: bucketId
      )
      throw error
    )

  ###
    Request overview load from server
  ###
  loadTransformationOverview: (bucketId, transformationId, showDisabled) ->
    actions = @
    _.defer( ->
      # trigger load initialized
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_OVERVIEW_LOAD
        transformationId: transformationId
        bucketId: bucketId
      )

      tableId = bucketId + "." + transformationId
      # init load
      transformationsApi
      .getGraph
        tableId: tableId
        direction: 'around'
        showDisabled: showDisabled
        limit: {sys: [bucketId]}
      .then((graphData) ->
        # load success
        dispatcher.handleViewAction(
          type: constants.ActionTypes.TRANSFORMATION_OVERVIEW_LOAD_SUCCESS
          transformationId: transformationId
          bucketId: bucketId
          model: graphData
        )

      )
      .catch((error) ->
        dispatcher.handleViewAction(
          type: constants.ActionTypes.TRANSFORMATION_OVERVIEW_LOAD_ERROR
          transformationId: transformationId
          bucketId: bucketId
        )
        throw error
      )
    )

  showTransformationOverviewDisabled: (bucketId, transformationId, showDisabled) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_OVERVIEW_SHOW_DISABLED
      transformationId: transformationId
      bucketId: bucketId
      showDisabled: showDisabled
    )
    @loadTransformationOverview(bucketId, transformationId, showDisabled)

  toggleOpenInputMapping: (bucketId, transformationId, index) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_INPUT_MAPPING_OPEN_TOGGLE
      transformationId: transformationId
      bucketId: bucketId
      index: index
    )

  toggleOpenOutputMapping: (bucketId, transformationId, index) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_OUTPUT_MAPPING_OPEN_TOGGLE
      transformationId: transformationId
      bucketId: bucketId
      index: index
    )

  startTransformationEdit: (bucketId, transformationId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_EDIT_START
      transformationId: transformationId
      bucketId: bucketId
    )

  cancelTransformationEdit: (bucketId, transformationId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_EDIT_CANCEL
      transformationId: transformationId
      bucketId: bucketId
    )

  saveTransformationEdit: (bucketId, transformationId) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_START
      transformationId: transformationId
      bucketId: bucketId
    )

    data = TransformationsStore.getEditingTransformationData(bucketId, transformationId).toJS()

    # parse queries
    if (data.backend == 'mysql' || data.backend == 'redshift')
      # taken and modified from
      # http://stackoverflow.com/questions/4747808/split-mysql-queries-in-array-each-queries-separated-by/5610067#5610067
      # removed multiline comment part
      regex = '\s*((?:\'[^\'\\\\]*(?:\\\\.[^\'\\\\]*)*\'|"[^"\\\\]*(?:\\\\.[^"\\\\]*)*"|\#.*|--.*|[^"\';#])+(?:;|$))'
      re = new RegExp(regex, 'g')
      matches = data.queries.match(re)
      matches = _.map(_.filter(matches, (line) ->
        line.trim() != ''
      ), (line) ->
        line.trim()
      )
      data.queries = matches
    else
      data.queries = [data.queries]

    transformationsApi
    .saveTransformation(bucketId, transformationId, data)
    .then (response) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_SUCCESS
        transformationId: transformationId
        bucketId: bucketId
        data: response
      )
    .catch (error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.TRANSFORMATION_EDIT_SAVE_ERROR
        transformationId: transformationId
        bucketId: bucketId
        error: error
      )
      throw error


  updateTransformationEdit: (bucketId, transformationId, data) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.TRANSFORMATION_EDIT_CHANGE
      transformationId: transformationId
      bucketId: bucketId
      data: data
    )
