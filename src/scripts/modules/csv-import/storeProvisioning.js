import {List, Map} from 'immutable';
import _ from 'underscore';

import InstalledComponentStore from '../components/stores/InstalledComponentsStore';

// utils
import {getDefaultTable} from './utils';

const COMPONENT_ID = 'keboola.csv-import';

// validovat soubor
function isUploaderValid(localState) {
  if (localState.has('file') && localState.get('file') && localState.get('file').size && localState.get('file').name) {
    return true;
  }
  return false;
}

function isUploaderFileTooBig(localState) {
  if (!localState.get('file')) {
    return false;
  }
  if (isUploaderValid(localState) && localState.get('file').size > 100 * 1024 * 1024) {
    return true;
  }
  return false;
}

function isUploaderFileInvalidFormat(localState) {
  if (!localState.get('file')) {
    return false;
  }
  if (!isUploaderValid(localState)) {
    return false;
  }
  const fileName = localState.get('file').name || '';
  if (fileName === '') {
    return false;
  }
  const suffix = fileName.substring(fileName.lastIndexOf('.'));
  return (['.csv', '.gz'].indexOf(suffix) === -1);
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
    isUploaderValid: isUploaderValid(localState) && !isUploaderFileInvalidFormat(localState),
    isUploaderFileTooBig: isUploaderFileTooBig(localState),
    isUploaderFileInvalidFormat: isUploaderFileInvalidFormat(localState),
    // local state stuff
    getLocalState(path) {
      if (_.isEmpty(path)) {
        return localState || Map();
      }
      return localState.getIn([].concat(path), Map());
    }
  };
}
