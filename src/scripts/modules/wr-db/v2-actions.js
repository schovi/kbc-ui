import {List, Map} from 'immutable';
import dockerProxyApi from './templates/dockerProxyApi';
import componentsActions from '../components/InstalledComponentsActionCreators';
import InstalledComponentStore from '../components/stores/InstalledComponentsStore';


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

  return {
    configTables: getconfigData().getIn(['parameters', 'tables'], List()),
    setTableInfo(tableId, newTableInfo) {
      updateLocalState(['v2', 'saving'], true);
      return dockerProxyApi(componentId).setTableV2(configId, tableId, newTableInfo)
        .then(() => updateLocalState(['v2', 'saving'], false));
    }

  };
}
