import installedComponentsActions from '../components/InstalledComponentsActionCreators';
import InstalledComponentStore from '../components/stores/InstalledComponentsStore';
import {List, Map, fromJS} from 'immutable';
import _ from 'underscore';

const componentId = 'geneea-nlp-analysis';

const LANGUAGE = 'language';
const OUTPUT = 'output';
const PRIMARYKEY = 'id_column';
const ANALYSIS = 'analysis_types';
const DATACOLUMN = 'data_column';

export const params = {LANGUAGE, OUTPUT, PRIMARYKEY, ANALYSIS, DATACOLUMN};

function getLocalState(configId, path) {
  const state = InstalledComponentStore.getLocalState(componentId, configId);
  if (path) {
    return state.getIn(path);
  } else {
    return state;
  }
}

export function updateLocalState(configId, path, data) {
  const newState = InstalledComponentStore.getLocalState(componentId, configId).setIn(path, data);
  installedComponentsActions.updateLocalState(componentId, configId, newState);
}

function getConfigData(configId) {
  return InstalledComponentStore.getConfigData(componentId, configId) || Map();
}

export function getInTable(configId) {
  const configData = getConfigData(configId);
  return configData.getIn(['storage', 'input', 'tables', 0], Map()).get('source');
}

function setEditingData(configId, data) {
  updateLocalState(configId, ['editing'], data);
}

export function updateEditingValue(configId, prop, value) {
  const data = getLocalState(configId, ['editing']) || Map();
  setEditingData(configId, data.set(prop, value));
}

export function getEditingValue(configId, prop) {
  return getLocalState(configId, ['editing', prop]);
}

export function startEditing(configId) {
  const configData = getConfigData(configId);
  let editingData = _.reduce(_.values(params), (memo, key) => {
    let defaultVal = '';
    if (key === ANALYSIS) {
      defaultVal = [];
    }
    if (key === LANGUAGE) {
      defaultVal = 'en';
    }
    if (key === OUTPUT) {
      defaultVal = 'out.c-nlp.';
    }
    const value = configData.getIn(['parameters', key], defaultVal);
    memo[key] = value;
    return memo;
  }, {});
  editingData.intable = getInTable(configId) || {};
  setEditingData(configId, fromJS(editingData));
}

export function isOutputValid(output) {
  return output.match(/(out|in)\..+\..*/);
}

const mandatoryParams = [PRIMARYKEY, DATACOLUMN, ANALYSIS, OUTPUT, 'intable'];
export function isValid(configId) {
  const isMissing = mandatoryParams.reduce((memo, param) => {
    let editingValue = getEditingValue(configId, param);
    if (editingValue && param === ANALYSIS) {
      editingValue = editingValue.toJS();
    }
    return memo || _.isEmpty(editingValue);
  }, false);
  const output = getEditingValue(configId, OUTPUT);

  return (!isMissing) && isOutputValid(output);
}

export function cancel(configId) {
  setEditingData(configId, null);
}

function prepareOutTables(tasks, outBucket, primaryKey, allTables) {
  let result = [];
  const isPKEqual = (key) => key === primaryKey;
  for (let task of tasks) {
    const tableId = `${outBucket}${task}`;
    const table = allTables.get(tableId, Map());
    const tableExists = !!(allTables.get(tableId, false));
    const tablePks = table.get('primaryKey', List());
    // if there is exactly one PK and equals to primaryKey param
    const hasPrimaryKey = tablePks.count() === 1 && !!(tablePks.find(isPKEqual));
    result.push({
      'source': `${tableId}.csv`,
      'destination': tableId,
      'primary_key': [primaryKey],
      'incremental': !tableExists || hasPrimaryKey
    });
  }
  return result;
}

export function updateEditingMapping(configId, newMapping) {
  updateEditingValue(configId, 'inputMapping', newMapping);
}

export function resetEditingMapping(configId, newIntableId) {
  updateEditingValue(configId, 'inputMapping', fromJS({source: newIntableId}));
}

export function getInputMapping(configId, isEditing) {
  const configData = getConfigData(configId);
  const ls = getLocalState(configId, ['editing']) || Map();
  const defaultMapping = fromJS({
    source: ''
  });
  const configMapping = configData.getIn(['storage', 'input', 'tables', 0], defaultMapping);
  const editingMapping = ls.get('inputMapping', configMapping);
  if (isEditing) {
    return editingMapping;
  } else {
    return configMapping;
  }
}

export function save(configId, allTables) {
  const data = getLocalState(configId, ['editing']).toJS();
  const primaryKey = data[params.PRIMARYKEY];
  console.log('EDITING DATA TO SAVE', data, allTables);
  const inputMapping = getInputMapping(configId, true);
  const columns = [data[params.DATACOLUMN], primaryKey];
  const storage = {
    input: {
      tables: [ fromJS(inputMapping.set('columns', columns))]
    },
    output: {
      tables: prepareOutTables(data[params.ANALYSIS], data[params.OUTPUT], primaryKey, allTables)

    }
  };

  const parameters = _.reduce(_.values(params), (memo, key) => {
    memo[key] = data[key];
    return memo;
  }, {});

  let config = fromJS({
    storage: storage,
    parameters: parameters
  });
  config = config.setIn(['parameters', 'user_key'], '9cf1a9a51553e32fda1ecf101fc630d5');
  const saveFn = installedComponentsActions.saveComponentConfigData;
  saveFn(componentId, configId, config).then( () => {
    return cancel(configId);
  });
}
