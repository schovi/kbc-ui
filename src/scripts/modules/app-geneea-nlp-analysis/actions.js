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

const params = { BETA, LANGUAGE, OUTPUT, PRIMARYKEY, ANALYSIS, DATACOLUMN};
console.log(params);
export default params;

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

export function startEditing(configId){
  const configData = getConfigData(configId);
  let editingData = _.reduce(_.values(params), (memo, key) =>
           {
             let defaultVal = '';
             if (key === ANALYSIS){
               defaultVal = [];
             }
             const value = configData.getIn(['parameters', key], defaultVal);
             memo[key] = value;
             return memo;
           }, {});
  editingData.intable = getInTable(configId) || {};
  setEditingData(configId, fromJS(editingData));
}


export function save(configId){

}

export function cancel(configId){
  setEditingData(configId, null);
}
