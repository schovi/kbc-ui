import storeProvisioning from './storeProvisioning';
import componentsActions from '../components/InstalledComponentsActionCreators';
import _ from 'underscore';
const COMPONENT_ID = 'keboola.ex-google-analytics-v4';

export default function(configId) {
  const store = storeProvisioning(configId);

  function updateLocalState(path, data) {
    const ls = store.getLocalState();
    const newLocalState = ls.setIn([].concat(path), data);
    componentsActions.updateLocalState(COMPONENT_ID, configId, newLocalState);
  }

  return {
    // returns localState for @path and function to update local state
    // on @path+@subPath
    prepareLocalState(path) {
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
        updateLocalState: updateLocalSubstateFn
      };
    }
  };
}
