import storeProvisioning from './storeProvisioning';
import _ from 'underscore';
import {fromJS} from 'immutable';
import componentsActions from '../components/InstalledComponentsActionCreators';
import callDockerAction from '../components/DockerActionsApi';

// PROPTYPES HELPER:
/*
  localState: PropTypes.object.isRequired,
  updateLocalState: PropTypes.func.isRequired,
  prepareLocalState: PropTypes.func.isRequired
*/

const COMPONENT_ID = 'keboola.ex-facebook';

export default function(configId) {
  const store = storeProvisioning(configId);

  function updateLocalState(path, data) {
    const ls = store.getLocalState();
    const newLocalState = ls.setIn([].concat(path), data);
    componentsActions.updateLocalState(COMPONENT_ID, configId, newLocalState, path);
  }

  function saveConfigData(data, waitingPath, changeDescription) {
    let dataToSave = data;
    updateLocalState(waitingPath, true);
    return componentsActions.saveComponentConfigData(COMPONENT_ID, configId, dataToSave, changeDescription)
      .then(() => updateLocalState(waitingPath, false));
  }


  // returns localState for @path and function to update local state
  // on @path+@subPath
  function prepareLocalState(path) {
    const ls = store.getLocalState(path);
    const updateLocalSubstateFn = (subPath, newData)  =>  {
      if (_.isEmpty(subPath)) {
        return updateLocalState([].concat(path), newData);
      } else {
        return updateLocalState([].concat(path).concat(subPath), newData);
      }
    };
    return {
      localState: ls,
      updateLocalState: updateLocalSubstateFn,
      prepareLocalState: (newSubPath) => prepareLocalState([].concat(path).concat(newSubPath))
    };
  }

  function generateId() {
    const existingIds = store.queries.map((q) => q.get('id'));
    const randomNumber = () => Math.floor((Math.random() * 100000) + 1);
    let newId = randomNumber();
    while (existingIds.indexOf(newId) >= 0) {
      newId = randomNumber();
    }
    return newId;
  }

  function touchQuery() {
    return fromJS({
      'id': generateId(),
      'type': 'nested-query',
      'name': '',
      'query': {
        'path': '',
        'fields': '',
        'ids': '',
        'limit': '25'
      }
    });
  }

  function saveAccounts(newAccounts) {
    const msg = 'Update selected pages';
    const data = store.configData.setIn(['parameters', 'accounts'], newAccounts);
    return saveConfigData(data, store.accountsSavingPath, msg);
  }

  function saveQueries(newQueries, savingPath, changeDescription) {
    const msg = changeDescription || 'Update queries';
    const data = store.configData.setIn(['parameters', 'queries'], newQueries);
    return saveConfigData(data, savingPath, msg);
  }

  function saveQuery(query) {
    const qid = query.get('id');
    let found = false;
    let action = 'Update query';
    let newQueries = store.queries.map((q) => {
      if (q.get('id') === qid) {
        found = true;
        return query;
      } else {
        return q;
      }});
    if (!found) {
      action = 'Add query';
      newQueries = newQueries.push(query);
    }
    return saveQueries(newQueries, store.getSavingQueryPath(qid), `${action} ${query.get('name')}`);
  }

  return {
    saveQuery: saveQuery,
    prepareLocalState: prepareLocalState,
    updateLocalState: updateLocalState,
    saveQueries: saveQueries,
    generateId: generateId,
    saveAccounts: saveAccounts,
    touchQuery: touchQuery,
    loadAccounts() {
      if (!store.isAuthorized()) return null;
      if ((store.syncAccounts.get('data') && !store.syncAccounts.get('isError')) || store.syncAccounts.get('isLoading')) return null;
      const path = store.syncAccountsPath;
      const data = store.configData;
      const params = {
        configData: data.toJS()
      };
      updateLocalState(path.concat('isLoading'), true);
      return callDockerAction(COMPONENT_ID, 'accounts', params)
        .then((accounts) =>
              updateLocalState(path, fromJS({
                isLoading: false,
                isError: false,
                error: null,
                data: accounts.map((a) => {delete a.perms; return a;})
              })))
        .catch((error) =>
               updateLocalState(path, fromJS({
                 isLoading: false,
                 isError: true,
                 error: error,
                 data: []
               })));
    }
  };
}
