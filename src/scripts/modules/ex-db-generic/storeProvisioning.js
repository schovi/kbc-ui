import store from '../components/stores/InstalledComponentsStore';
import {Map} from 'immutable';
import fuzzy from 'fuzzy';

function fetch(componentId, configId) {
  const config = store.getConfigData(componentId, configId) || Map();
  return {
    config: config,
    parameters: config.get('parameters'),
    localState: store.getLocalState(componentId, configId) || Map()
  };
}

export function getLocalState(componentId, configId) {
  return fetch(componentId, configId).localState;
}

export const componentsStore = store;
export function createStore(componentId, configId) {
  const data = fetch(componentId, configId);

  return {
    getQueriesPendingActions() {
      return data.localState.getIn(['pending', 'queries']);
    },

    getQueriesFilter() {
      return data.localState.get('queriesFilter');
    },

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
    }

  };
}
