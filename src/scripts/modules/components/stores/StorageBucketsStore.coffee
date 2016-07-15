Dispatcher = require('../../../Dispatcher')
constants = require '../Constants'
Immutable = require('immutable')
Map = Immutable.Map
List = Immutable.List
fromJS = Immutable.fromJS
StoreUtils = require '../../../utils/StoreUtils'
_ = require 'underscore'

_store = Map(
  buckets: Map()
  isLoaded: false
  isLoading: false
  credentials: Map() #bucketId
  pendingCredentials: Map() #(loading, deleting, creating)
  pendingBuckets: Map() #(creating)
)

StorageBucketsStore = StoreUtils.createStore

  getAll: ->
    _store.get 'buckets'

  getIsLoading: ->
    _store.get 'isLoading'

  getIsLoaded: ->
    _store.get 'isLoaded'

  hasBucket: (bucketId) ->
    _store.get('buckets').has(bucketId)

  isCreatingBucket: ->
    _store.getIn ['pendingBuckets', 'creating'], false

  hasCredentials: (bucketId) ->
    _store.get('credentials').has(bucketId)

  getCredentials: (bucketId) ->
    _store.getIn(['credentials', bucketId])

  isCreatingCredentials: ->
    _store.getIn ['pendingCredentials', 'creating'], false

  isDeletingCredentials: ->
    _store.getIn ['pendingCredentials', 'deleting'], false

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when constants.ActionTypes.STORAGE_BUCKETS_LOAD
      _store = _store.set 'isLoading', true
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKETS_LOAD_SUCCESS
      _store = _store.withMutations (store) ->
        store = store.setIn ['buckets'], Map()
        _.each(action.buckets, (bucket) ->
          bObj = Immutable.fromJS(bucket)
          store = store.setIn ['buckets', bObj.get 'id'], bObj
        )
        store.set 'isLoading', false
        store.set 'isLoaded', true
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKETS_LOAD_ERROR
      _store = _store.set 'isLoading', false
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_CREATE
      bucketId = action.bucketId
      _store = _store.setIn(['pendingCredentials', 'creating'], true)
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_CREATE_SUCCESS
      bucketId = action.bucketId
      newCreds = fromJS action.credentials
      _store = _store.setIn(['pendingCredentials', 'creating'], false)
      creds = StorageBucketsStore.getCredentials(bucketId) or List()
      _store = _store.setIn ['credentials', bucketId], creds.push(newCreds)
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_LOAD
      bucketId = action.bucketId
      _store = _store.setIn(['pendingCredentials', bucketId, 'loading'], true)
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_LOAD_SUCCESS
      bucketId = action.bucketId
      credentials = fromJS action.credentials
      _store = _store.deleteIn(['pendingCredentials', bucketId, 'loading'])

      _store = _store.setIn ['credentials', bucketId], credentials
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_DELETE
      bucketId = action.bucketId
      credentialsId = action.credentialsId
      _store = _store.setIn ['pendingCredentials', 'deleting'], true
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKET_CREDENTIALS_DELETE_SUCCESS
      bucketId = action.bucketId
      credentialsId = action.credentialsId
      _store = _store.deleteIn ['pendingCredentials', 'deleting']
      creds = StorageBucketsStore.getCredentials(bucketId).filter((c) ->
        c.get('id') != credentialsId)
      _store = _store.setIn ['credentials', bucketId], creds
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKET_CREATE
      _store = _store.setIn ['pendingBuckets', 'creating'], true
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKET_CREATE_SUCCESS
      _store = _store.setIn ['pendingBuckets', 'creating'], false
      _store = _store.setIn ['buckets', action.bucket.id], Immutable.fromJS(action.bucket)
      console.log(_store.getIn(['buckets']).toJS())
      StorageBucketsStore.emitChange()

    when constants.ActionTypes.STORAGE_BUCKET_CREATE_ERROR
      _store = _store.setIn ['pendingBuckets', 'creating'], false
      StorageBucketsStore.emitChange()

module.exports = StorageBucketsStore
