import {List, Map} from 'immutable';
import _ from 'underscore';

import InstalledComponentStore from '../components/stores/InstalledComponentsStore';

// utils
import {getDefaultTable} from './utils';

const COMPONENT_ID = 'keboola.csv-import';

// validovat soubor
function isUploaderValid(localState) {
  return localState.has('name') && localState.has('size') && localState.get('name') !== '' && localState.get('size') > 0;
}

export default function(configId) {
  const localState = InstalledComponentStore.getLocalState(COMPONENT_ID, configId) || Map();
  const configData =  InstalledComponentStore.getConfigData(COMPONENT_ID, configId) || Map();

  return {
    destination: configData.get('destination', getDefaultTable(configId)),
    incremental: configData.get('incremental', false),
    primaryKey: configData.get('primaryKey', List()),
    delimiter: configData.get('delimiter', ','),
    enclosure: configData.get('enclosure', '"'),

    isUploaderValid: isUploaderValid(localState),
    // local state stuff
    getLocalState(path) {
      if (_.isEmpty(path)) {
        return localState || Map();
      }
      return localState.getIn([].concat(path), Map());
    }
  };
}
