import * as storeProvisioning from './storeProvisioning';
import {Map, List} from 'immutable';
import componentsActions from '../components/InstalledComponentsActionCreators';
import callDockerAction from '../components/DockerActionsApi';

import getDefaultPort from './templates/defaultPorts';

export function loadConfiguration(componentId, configId) {
  return componentsActions.loadComponentConfigData(componentId, configId);
}

export function createActions(componentId) {
  function getStore(configId) {
    return storeProvisioning.createStore(componentId, configId);
  }

  function localState(configId) {
    return storeProvisioning.getLocalState(componentId, configId);
  }

  function updateLocalState(configId, path, data) {
    const ls = localState(configId);
    const newLocalState = ls.setIn([].concat(path), data);
    componentsActions.updateLocalState(componentId, configId, newLocalState);
  }

  function saveConfigData(configId, data, waitingPath) {
    updateLocalState(configId, waitingPath, true);
    return componentsActions.saveComponentConfigData(componentId, configId, data)
      .then(() => updateLocalState(configId, waitingPath, false));
  }

  return {
    setQueriesFilter(configId, query) {
      updateLocalState(configId, 'queriesFilter', query);
    },

    editCredentials(configId) {
      const store = getStore(configId);
      let credentials = store.getCredentials();
      if (!credentials.get('port')) {
        credentials = credentials.set('port', getDefaultPort(componentId));
      }
      updateLocalState(configId, 'editingCredentials', credentials);
    },

    cancelCredentialsEdit(configId) {
      updateLocalState(configId, 'editingCredentials', null);
    },

    updateEditingCredentials(configId, newCredentials) {
      updateLocalState(configId, 'editingCredentials', newCredentials);
    },

    resetNewQuery(configId) {
      updateLocalState(configId, ['newQueries'], Map());
    },

    changeQueryEnabledState(configId, qid, newValue) {
      const store = getStore(configId);
      const newQueries = store.getQueries().map((q) => {
        if (q.get('outputTable') === qid) {
          return q.set('enabled', newValue);
        } else {
          return q;
        }
      });
      const newData = store.configData.setIn(['parameters', 'tables'], newQueries);
      return saveConfigData(configId, newData, ['pending', qid, 'enabled']);
    },

    updateNewQuery(configId, newQuery) {
      updateLocalState(configId, ['newQueries', 'query'], newQuery);
    },

    resetNewCredentials(configId) {
      updateLocalState(configId, ['newCredentials'], null);
    },

    updateNewCredentials(configId, newCredentials) {
      updateLocalState(configId, ['newCredentials'], newCredentials);
    },

    saveNewCredentials(configId) {
      const store = getStore(configId);
      const newCredentials = store.getNewCredentials();
      const newData = store.configData.setIn(['parameters', 'db'], newCredentials);
      return saveConfigData(configId, newData, ['isSavingCredentials']).then(() => this.resetNewCredentials(configId));
    },

    checkTableName(query, store) {
      const defaultTableName = store.getDefaultOutputTableId(query);
      if (query.get('outputTable', '').trim().length > 0) {
        return query;
      } else {
        return query.set('outputTable', defaultTableName);
      }
    },

    createQuery(configId) {
      const store = getStore(configId);
      const newQuery = this.checkTableName(store.getNewQuery(), store);
      const newQueries = store.getQueries().push(newQuery);
      const newData = store.configData.setIn(['parameters', 'tables'], newQueries);
      return saveConfigData(configId, newData, ['newQueries', 'isSaving']).then(() => this.resetNewQuery(configId));
    },

    saveCredentialsEdit(configId) {
      const store = getStore(configId);
      const credentials = store.getEditingCredentials();
      const newConfigData = store.configData.setIn(['parameters', 'db'], credentials);
      return saveConfigData(configId, newConfigData, 'isSavingCredentials').then(() => this.cancelCredentialsEdit(configId));
    },

    deleteQuery(configId, qid) {
      const store = getStore(configId);
      const newQueries = store.getQueries().filter((q) => q.get('outputTable') !== qid);
      const newData = store.configData.setIn(['parameters', 'tables'], newQueries);
      return saveConfigData(configId, newData, ['pending', qid, 'deleteQuery']);
    },

    updateEditingQuery(configId, query) {
      const queryId = query.get('outputTable');
      updateLocalState(configId, ['editingQueries', queryId], query);
    },

    editQuery(configId, queryId) {
      let query = getStore(configId).getConfigQuery(queryId);
      query = query.set('newOutputTable', query.get('outputTable'));
      updateLocalState(configId, ['editingQueries', queryId], query);
    },

    cancelQueryEdit(configId, queryId) {
      updateLocalState(configId, ['editingQueries', queryId], null);
    },

    saveQueryEdit(configId, queryId) {
      const store = getStore(configId);
      let newQuery = store.getEditingQuery(queryId);
      newQuery = this.checkTableName(newQuery, store);
      const newQueries = store.getQueries().map((q) => q.get('outputTable') === queryId ? newQuery : q);
      const newData = store.configData.setIn(['parameters', 'tables'], newQueries);
      saveConfigData(configId, newData, ['savingQueries']).then(() => this.cancelQueryEdit(configId, queryId));
    },

    testCredentials(configId, credentials) {
      const store = getStore(configId);
      let runData = store.configData.setIn(['parameters', 'tables'], List());
      runData = runData.setIn(['parameters', 'db'], credentials);
      const params = {
        configData: runData.toJS()
      };
      return callDockerAction(componentId, 'testConnection', params);
    },

    prepareSingleQueryRunData(configId, query) {
      const store = getStore(configId);
      const runData = store.configData.setIn(['parameters', 'tables'], List().push(query));
      return runData;
    }
  };
}
