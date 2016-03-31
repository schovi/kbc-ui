StoreUtils = require '../../../utils/StoreUtils'
Immutable = require 'immutable'
dispatcher = require '../../../Dispatcher'
Constants = require '../VersionsConstants'
fuzzy = require 'fuzzy'

{Map, List} = Immutable

_store = Map
  loadingVersions: Map()
  rollbackVersions: Map()
  versions: Map()
  newVersionNames: Map()
  searchFilters: Map()

VersionsStore = StoreUtils.createStore
  hasVersions: (componentId, configId) ->
    _store.hasIn ['versions', componentId, configId]

  hasVersion: (componentId, configId, versionId) ->
    _store.hasIn ['versions', componentId, configId, versionId]

  isLoadingVersions: (componentId, configId) ->
    _store.getIn ['loadingVersions', componentId, configId], false

  getVersions: (componentId, configId) ->
    _store.getIn ['versions', componentId, configId], List()

  getFilteredVersions: (componentId, configId) ->
    versions = @getVersions(componentId, configId)
    query = @getSearchFilter(componentId, configId)
    if (!query || query == '')
      return versions
    else
      return versions.filter((version) ->
        fuzzy.match(query, (String(version.get('version')) || '')) ||
        fuzzy.match(query, (version.get('changeDescription') || '')) ||
        fuzzy.match(query, (version.getIn(['creatorToken', 'description']) || '')) ||
        fuzzy.match(query, (String(version.get('created')) || ''))
      )

  getVersion: (componentId, configId, versionId) ->
    _store.getIn ['versions', componentId, configId, versionId], Map()

  getNewVersionNames: (componentId, configId) ->
    _store.getIn ['newVersionNames', componentId, configId], Map()

  getNewVersionName: (componentId, configId, version) ->
    _store.getIn ['newVersionNames', componentId, configId, version]

  getSearchFilter: (componentId, configId) ->
    _store.getIn ['searchFilters', componentId, configId], ''

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
      _store = _store.setIn(['rollbackVersions', action.componentId, action.configId], true)
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_ROLLBACK_SUCCESS
      _store = _store.setIn(['rollbackVersions', action.componentId, action.configId], false)
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_ROLLBACK_ERROR
      _store = _store.setIn(['rollbackVersions', action.componentId, action.configId], false)
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_COPY_START
      _store = _store.setIn(['rollbackVersions', action.componentId, action.configId], true)
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_COPY_SUCCESS
      _store = _store.setIn(['rollbackVersions', action.componentId, action.configId], false)
      _store = _store.deleteIn(['newVersionNames', action.componentId, action.configId])
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_COPY_ERROR
      _store = _store.setIn(['rollbackVersions', action.componentId, action.configId], false)
      _store = _store.deleteIn(['newVersionNames', action.componentId, action.configId])
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_NEW_NAME_CHANGE
      _store = _store.setIn(['newVersionNames', action.componentId, action.configId, action.version], action.name)
      VersionsStore.emitChange()

    when Constants.ActionTypes.VERSIONS_FILTER_CHANGE
      _store = _store.setIn(['searchFilters', action.componentId, action.configId], action.query)
      VersionsStore.emitChange()

module.exports = VersionsStore
