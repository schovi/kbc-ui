import installedComponentsActions from '../components/InstalledComponentsActionCreators';
import InstalledComponentStore from '../components/stores/InstalledComponentsStore';
import {Map, fromJS} from 'immutable';
import _ from 'underscore';

const componentId = 'geneea-nlp-analysis';

const BETA = 'use_beta';
const LANGUAGE = 'language';
const OUTPUT = 'output';
const PRIMARYKEY = 'id_column';
const ANALYSIS = 'analysis_types';
const DATACOLUMN = 'data_column';

export const params = { BETA, LANGUAGE, OUTPUT, PRIMARYKEY, ANALYSIS, DATACOLUMN};


function getLocalState(configId, path){
  const state = InstalledComponentStore.getLocalState(componentId, configId);
  if (path){
    return state.getIn(path);
  }
  else{
    return state;
  }

}
export function updateLocalState(configId, path, data){
  const newState = InstalledComponentStore.getLocalState(componentId, configId).setIn(path, data);
  installedComponentsActions.updateLocalState(componentId, configId, newState);
}

function getConfigData(configId){
  return InstalledComponentStore.getConfigData(componentId, configId) || Map();
}

export function getInTable(configId){
  const configData = getConfigData(configId);
  return configData.getIn(['storage', 'input', 'tables', 0], Map()).get('source');
}

function setEditingData(configId, data){
  updateLocalState(configId, ['editing'], data);
}

export function updateEditingValue(configId, prop, value){
  const data = getLocalState(configId, ['editing']);
  setEditingData(configId, data.set(prop, value));
}

export function getEditingValue(configId, prop){
  return getLocalState(configId, ['editing', prop]);

}

export function startEditing(configId){
  const configData = getConfigData(configId);
  let editingData = _.reduce(_.values(params), (memo, key) =>
           {
             let defaultVal = '';
             if (key === ANALYSIS){
               defaultVal = [];
             }
             if (key === LANGUAGE){
               defaultVal = 'en';
             }
             if (key === OUTPUT){
               defaultVal = 'out.c-nlp.';
             }
             if (key === BETA){
               defaultVal = false;
             }
             const value = configData.getIn(['parameters', key], defaultVal);
             memo[key] = value;
             return memo;
           }, {});
  editingData.intable = getInTable(configId) || {};
  setEditingData(configId, fromJS(editingData));
}

const mandatoryParams = [PRIMARYKEY, DATACOLUMN, ANALYSIS, OUTPUT, 'intable'];
export function isValid(configId){
  const isMissing = mandatoryParams.reduce((memo, param) => {
    let editingValue = getEditingValue(configId, param);
    if (editingValue && param === ANALYSIS){
      editingValue = editingValue.toJS();
    }
    return memo || _.isEmpty(editingValue);
  }, false);

  return !isMissing;
  //const missing = getLocalState(configId, ['missing']) || Map();
  //return !missing.reduce( (memo, value) => memo || value, false);
}

export function cancel(configId){
  setEditingData(configId, null);
}

export function save(configId){
  const data = getLocalState(configId, ['editing']).toJS();
  const storage = {
    input: {
      tables: [
        {
          source: data.intable,
          columns: [data[params.DATACOLUMN], data[params.PRIMARYKEY]]
        }
      ]
    }
  };
  const parameters = _.reduce(_.values(params), (memo, key) => {
    memo[key] = data[key];
    return memo;
  }, {});

  const config = {
    storage: storage,
    parameters: parameters
  };
  console.log('config to save', config);
  const saveFn = installedComponentsActions.saveComponentConfigData;
  saveFn(componentId, configId, fromJS(config)).then( () => {
    return cancel(configId);
  });
}
