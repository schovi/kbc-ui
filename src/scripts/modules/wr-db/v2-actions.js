import {List, Map} from 'immutable';
import dockerProxyApi from './templates/dockerProxyApi';
import componentsActions from '../components/InstalledComponentsActionCreators';
import InstalledComponentStore from '../components/stores/InstalledComponentsStore';
import callDockerAction from '../components/DockerActionsApi';
import credentialsFields from './templates/credentialsFields';


function getProtectedProperties(componentId) {
  let result = [];
  const fields = credentialsFields(componentId);
  for (let f of fields) {
    const propName = f[1];
    const isProtected = propName[0] === '#';
    if (isProtected) result.push(propName);
  }
  return result;
}

export default function(configId, componentId) {
  function localState() {
    return InstalledComponentStore.getLocalState(componentId, configId) || Map();
  }

  function updateLocalState(path, data) {
    const ls = localState();
    const newLocalState = ls.setIn([].concat(path), data);
    componentsActions.updateLocalState(componentId, configId, newLocalState, path);
  }

  function getconfigData() {
    return InstalledComponentStore.getConfigData(componentId, configId) || Map();
  }
  // if protected property is missing its value the use store valu
  // from @oldCredentials
  function updateProtectedProperties(newCredentials, oldCredentials) {
    const props = getProtectedProperties(componentId);
    let result = newCredentials;
    for (let prop of props) {
      const newValue = newCredentials.get(prop);
      const oldValue = oldCredentials.get(prop);
      if (!newValue) {
        result = result.set(prop, oldValue);
      }
    }
    return result;
  }


  return {

    editingPkPath: ['editingPk'],
    updateV2State: (path, data) => updateLocalState(['v2'].concat(path), data),
    configTables: getconfigData().getIn(['parameters', 'tables'], List()),
    setTableInfo(tableId, newTableInfo) {
      updateLocalState(['v2', 'saving'], true);
      return dockerProxyApi(componentId).setTableV2(configId, tableId, newTableInfo)
        .then(() => updateLocalState(['v2', 'saving'], false));
    },
    testCredentials(credentials) {
      // const store = getStore(configId);
      const configData = getconfigData();
      const storedCredentials = configData.getIn(['parameters', 'db']);
      const testingCredentials = updateProtectedProperties(credentials, storedCredentials);
      let runData = configData
          .setIn(['parameters', 'tables'], List())
          .delete('storage');

      runData = runData.setIn(['parameters', 'db'], testingCredentials);
      const params = {
        configData: runData.toJS()
      };
      return callDockerAction(componentId, 'testConnection', params);
    }

  };
}
