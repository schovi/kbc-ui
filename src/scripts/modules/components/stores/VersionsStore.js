import StoreUtils from '../../../utils/StoreUtils';
import Immutable from 'immutable';
import dispatcher from '../../../Dispatcher';
import Constants from '../VersionsConstants';

var Map = Immutable.Map, List = Immutable.List;

var _store = Map({
  loadingVersions: Map(),
  versions: Map(),
  newVersionNames: Map(),
  searchFilters: Map(),
  pending: Map()
});

var VersionsStore = StoreUtils.createStore({
  hasVersions: function(componentId, configId) {
    return _store.hasIn(['versions', componentId, configId]);
  },

  hasVersion: function(componentId, configId, versionId) {
    return _store.hasIn(['versions', componentId, configId, versionId]);
  },

  isLoadingVersions: function(componentId, configId) {
    return _store.getIn(['loadingVersions', componentId, configId], false);
  },

  getVersions: function(componentId, configId) {
    return _store.getIn(['versions', componentId, configId], List());
  },

  getVersion: function(componentId, configId, versionId) {
    return _store.getIn(['versions', componentId, configId, versionId], Map());
  },

  getNewVersionNames: function(componentId, configId) {
    return _store.getIn(['newVersionNames', componentId, configId], Map());
  },

  getNewVersionName: function(componentId, configId, version) {
    return _store.getIn(['newVersionNames', componentId, configId, version]);
  },

  getSearchFilter: function(componentId, configId) {
    return _store.getIn(['searchFilters', componentId, configId], '');
  },

  isPendingConfig: function(componentId, configId) {
    return _store.hasIn(['pending', componentId, configId], false);
  },

  getPendingVersions: function(componentId, configId) {
    return _store.getIn(['pending', componentId, configId], Map());
  }


});

dispatcher.register(function(payload) {
  var action;
  action = payload.action;

  switch (action.type) {

    case Constants.ActionTypes.VERSIONS_LOAD_START:
      _store = _store.setIn(['loadingVersions', action.componentId, action.configId], true);
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_LOAD_SUCCESS:
      _store = _store.setIn(['versions', action.componentId, action.configId], Immutable.fromJS(action.versions));
      _store = _store.setIn(['rollbackVersions', action.componentId, action.configId], false);
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_LOAD_ERROR:
      _store = _store.setIn(['loadingVersions', action.componentId, action.configId], false);
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_ROLLBACK_START:
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_ROLLBACK_SUCCESS:
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_ROLLBACK_ERROR:
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_COPY_START:
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_COPY_SUCCESS:
      _store = _store.deleteIn(['newVersionNames', action.componentId, action.configId]);
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_COPY_ERROR:
      _store = _store.deleteIn(['newVersionNames', action.componentId, action.configId]);
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_NEW_NAME_CHANGE:
      _store = _store.setIn(['newVersionNames', action.componentId, action.configId, action.version], action.name);
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_FILTER_CHANGE:
      _store = _store.setIn(['searchFilters', action.componentId, action.configId], action.query);
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_PENDING_START:
      _store = _store.setIn(['pending', action.componentId, action.configId, action.version, action.action], true);
      return VersionsStore.emitChange();

    case Constants.ActionTypes.VERSIONS_PENDING_STOP:
      _store = _store.deleteIn(['pending', action.componentId, action.configId]);
      return VersionsStore.emitChange();

    default:
  }
});

module.exports = VersionsStore;
