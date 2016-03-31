StoreUtils = require '../../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../../Dispatcher'
Constants = require '../VersionsConstants'

{Map, List} = Immutable

_store = Map
  loadingVersions: Map()
  versions: Map()
  newVersionNames: Map()
  searchFilters: Map()
  pending: Map()

VersionsStore = StoreUtils.createStore
  hasVersions: (componentId, configId) ->
    _store.hasIn ['versions', componentId, configId]

  hasVersion: (componentId, configId, versionId) ->
    _store.hasIn ['versions', componentId, configId, versionId]

  isLoadingVersions: (componentId, configId) ->
    _store.getIn ['loadingVersions', componentId, configId], false

  getVersions: (componentId, configId) ->
    _store.getIn ['versions', componentId, configId], List()

  getVersion: (componentId, configId, versionId) ->
    _store.getIn ['versions', componentId, configId, versionId], Map()

  getNewVersionNames: (componentId, configId) ->
    _store.getIn ['newVersionNames', componentId, configId], Map()

  getNewVersionName: (componentId, configId, version) ->
    _store.getIn ['newVersionNames', componentId, configId, version]

  getSearchFilter: (componentId, configId) ->
    _store.getIn ['searchFilters', componentId, configId], ''

  isPending: (componentId, configId) ->
    _store.getIn ['pending', componentId, configId], false

dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.VERSIONS_LOAD_START
      _store = _store.setIn(['loadingVersions', action.componentId, action.configId], true)
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_LOAD_SUCCESS
      _store = _store.setIn ['versions', action.componentId, action.configId], Immutable.fromJS(action.versions)
      _store = _store.setIn(['rollbackVersions', action.componentId, action.configId], false)
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_LOAD_ERROR
      _store = _store.setIn(['loadingVersions', action.componentId, action.configId], false)
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_ROLLBACK_START
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_ROLLBACK_SUCCESS
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_ROLLBACK_ERROR
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_COPY_START
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_COPY_SUCCESS
      _store = _store.deleteIn(['newVersionNames', action.componentId, action.configId])
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_COPY_ERROR
      _store = _store.deleteIn(['newVersionNames', action.componentId, action.configId])
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_NEW_NAME_CHANGE
      _store = _store.setIn(['newVersionNames', action.componentId, action.configId, action.version], action.name)
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_FILTER_CHANGE
      _store = _store.setIn(['searchFilters', action.componentId, action.configId], action.query)
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_PENDING_START
      _store = _store.setIn(['pending', action.componentId, action.configId], true)
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_PENDING_STOP
      _store = _store.deleteIn(['pending', action.componentId, action.configId])
      VersionsStore.emitChange()


module.exports = VersionsStore
