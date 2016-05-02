import store from '../components/stores/InstalledComponentsStore';
import {List, Map, fromJS} from 'immutable';
import fuzzy from 'fuzzy';
import templateFields from './templates/credentials';
import hasSshTunnel from './templates/hasSshTunnel';
import _ from 'underscore';
import string from '../../utils/string';
import getDefaultPort from './templates/defaultPorts';

function fetch(componentId, configId) {
  const config = store.getConfigData(componentId, configId) || Map();
  return {
    config: config || Map(),
    parameters: config.get('parameters', Map()),
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
  const nameValid = query.get('name', '').trim().length > 0;
  const queryValid = query.get('query', '').trim().length > 0;
  return nameValid && queryValid;
}

export function getLocalState(componentId, configId) {
  return fetch(componentId, configId).localState;
}

export const componentsStore = store;
export function createStore(componentId, configId) {
  const data = fetch(componentId, configId);


  return {
    hasValidCredentials(credentials) {
      if (!credentials) {
        return false;
      }
      const hasSSH = hasSshTunnel(componentId);
      const fields = templateFields.getFields(componentId);
      const validGeneralCreds = _.reduce(fields, (memo, field) => {
        const propName = field[1];
        // const type = field[2];
        let value = credentials.get(propName, '');
        if (value) {
          value = value.toString();
        }
        return memo && !_.isEmpty(value);
      }, true);
      const ssh = credentials.get('ssh', Map());
      const sshFields = [
        ['sshHost', 'text'],
        ['user', 'text'],
        ['sshPort', 'number']
      ];
      const isValidSSH = _.reduce(sshFields, (memo, field) => {
        const propName = field[0];
        let value = ssh.get(propName, '');
        if (value) {
          value = value.toString();
        }
        return memo && !_.isEmpty(value);
      }, true);
      const hasKeys = ssh.getIn(['keys', 'public']) && ssh.getIn(['keys', '#private']);
      let sshValid = true;
      if (hasSSH && ssh.get('enabled')) {
        sshValid = hasKeys && isValidSSH;
      }
      return validGeneralCreds && sshValid;
    },

    // -------- LOCAL STATE manipulation -----------------
    getDefaultOutputTableId(query) {
      if (!query) {return ''; }
      const qname = string.sanitizeKbcTableIdString(query.get('name', ''));
      const bucketName = string.sanitizeKbcTableIdString(componentId);
      return `in.c-${bucketName}.${qname}`;
    },
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
      var defaultNewCredentials = data.parameters.get('db', Map());
      if (!defaultNewCredentials.get('port')) {
        defaultNewCredentials = defaultNewCredentials.set('port', getDefaultPort(componentId));
      }
      const result = data.localState.get('newCredentials', defaultNewCredentials);
      if (result) {
        return result;
      } else {
        return defaultNewCredentials;
      }
    },

    getNewQuery() {
      const ids = this.getQueries().map((q) => q.get('outputTable')).toJS();
      const defaultNewQuery = fromJS({
        enabled: true,
        incremental: false,
        outputTable: '',
        primaryKey: [],
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
    outTableExist(query) {
      if (!query) {
        return false;
      }
      const currentOutputTable = query.get('outputTable');
      const editingOutpuTable = query.get('newOutputTable');
      const found = this.getQueries().find((q) => {
        const outTable = q.get('outputTable');
        return outTable === editingOutpuTable && outTable !== currentOutputTable;
      });
      return !!found;
    },

    isEditingQueryValid(queryId) {
      const query = this.getEditingQuery(queryId);
      if (!query) {
        return false;
      }

      return !this.outTableExist(query) && isValidQuery(query);
    },
    // -------- CONFIGDATA manipulation -----------------
    configData: data.config,

    getQueries() {
      return data.parameters.get('tables', List()).map((q) => {
        let pk = q.get('primaryKey', null);
        if (_.isEmpty(pk) || _.isString(pk)) {
          pk = List();
        }
        return q.set('primaryKey', pk);
      });
    },

    getQueriesFiltered() {
      const q = this.getQueriesFilter();
      return this.getQueries().filter( (query) => {
        return fuzzy.match(q, query.get('name')) ||
          fuzzy.match(q, query.get('outputTable'));
      }).sortBy((query) => query.get('name').toLowerCase());
    },

    getCredentials() {
      return data.parameters.get('db', Map());
    },

    getConfigQuery(qid) {
      return this.getQueries().find((q) => q.get('outputTable') === qid );
    }

  };
}
