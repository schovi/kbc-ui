import store from '../components/stores/InstalledComponentsStore';
import {Map, fromJS} from 'immutable';
import fuzzy from 'fuzzy';

function fetch(componentId, configId) {
  const config = store.getConfigData(componentId, configId) || Map();
  return {
    config: config,
    parameters: config.get('parameters'),
    localState: store.getLocalState(componentId, configId) || Map()
  };
}

function generateId(existingIds) {
  const randomNumber = () => Math.floor((Math.random() * 100000) + 1);
  let newId = randomNumber();
  while (existingIds.indexOf(newId) >= 0) {
    newId = randomNumber();
  }
  return newId;
}

function isValidQuery(query) {
  return query.get('name', '').trim().length > 0;
}

export function getLocalState(componentId, configId) {
  return fetch(componentId, configId).localState;
}

export const componentsStore = store;
export function createStore(componentId, configId) {
  const data = fetch(componentId, configId);

  return {
    // -------- LOCAL STATE manipulation -----------------
    getQueriesPendingActions() {
      return data.localState.getIn(['pending'], Map());
    },

    getQueriesFilter() {
      return data.localState.get('queriesFilter', '');
    },

    isEditingCredentials() {
      return !!data.localState.get('editingCredentials');
    },

    isSavingCredentials() {
      return data.localState.get('isSavingCredentials', false);
    },

    getEditingCredentials() {
      return data.localState.get('editingCredentials');
    },

    isSavingNewQuery() {
      return data.localState.getIn(['newQueries', 'isSaving']);
    },

    isValidNewQuery() {
      const query = this.getNewQuery();
      return isValidQuery(query);
    },

    getNewCredentials() {
      const defaultNewCredentials = data.parameters.get('db');
      return data.localState.get('newCredentials', defaultNewCredentials);
    },

    getNewQuery() {
      const ids = this.getQueries().map((q) => q.get('id')).toJS();
      const defaultNewQuery = fromJS({
        incremental: false,
        outputTable: '',
        primaryKey: '',
        query: '',
        id: generateId(ids)
      });
      return data.localState.getIn(['newQueries', 'query'], defaultNewQuery);
    },

    isEditingQuery(queryId) {
      return !!data.localState.getIn(['editingQueries', queryId]);
    },

    getEditingQuery(queryId) {
      return data.localState.getIn(['editingQueries', queryId]);
    },

    isSavingQuery() {
      return data.localState.get('savingQueries');
    },

    isEditingQueryValid(queryId) {
      const query = this.getEditingQuery(queryId);
      if (!query) {
        return false;
      }
      return isValidQuery(query);
    },
    // -------- CONFIGDATA manipulation -----------------
    configData: data.config,

    getQueries() {
      return data.parameters.get('tables');
    },

    getQueriesFiltered() {
      const q = this.getQueriesFilter();
      return this.getQueries().filter( (query) => {
        return fuzzy.match(q, query.get('name')) ||
          fuzzy.match(q, query.get('outputTable'));
      }).sortBy((query) => query.get('name').toLowerCase());
    },

    getCredentials() {
      return data.parameters.get('db');
    },

    getConfigQuery(qid) {
      return this.getQueries().find((q) => q.get('id') === qid );
    }

  };
}
