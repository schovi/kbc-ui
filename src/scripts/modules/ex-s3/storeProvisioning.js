import {Map} from 'immutable';
import _ from 'underscore';

import InstalledComponentStore from '../components/stores/InstalledComponentsStore';
import {parseConfiguration} from './utils';

const COMPONENT_ID = 'keboola.ex-s3';

export default function(configId) {
  const localState = InstalledComponentStore.getLocalState(COMPONENT_ID, configId) || Map();
  const configData =  InstalledComponentStore.getConfigData(COMPONENT_ID, configId) || Map();

  let retVal = parseConfiguration(configData.toJS(), configId);
  retVal.getLocalState = function(path) {
    if (_.isEmpty(path)) {
      return localState || Map();
    }
    return localState.getIn([].concat(path), Map());
  };
  return retVal;
}
