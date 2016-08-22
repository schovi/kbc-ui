import storeProvisioning from './storeProvisioning';
// import {Map, fromJS} from 'immutable';
import * as common from './common';
import componentsActions from '../components/InstalledComponentsActionCreators';
import _ from 'underscore';
const COMPONENT_ID = 'keboola.ex-google-drive';

// PROPTYPES HELPER:
/*
  localState: PropTypes.object.isRequired,
  updateLocalState: PropTypes.func.isRequired,
  prepareLocalState: PropTypes.func.isRequired
*/

export default function(configId) {
  const store = storeProvisioning(configId);

  function updateLocalState(path, data) {
    const ls = store.getLocalState();
    const newLocalState = ls.setIn([].concat(path), data);
    componentsActions.updateLocalState(COMPONENT_ID, configId, newLocalState);
  }

  function saveConfigData(data, waitingPath, changeDescription) {
    let dataToSave = data;
    // check default output bucket and save default if non set
    const ob = dataToSave.getIn(['parameters', 'outputBucket']);
    if (!ob) {
      dataToSave = dataToSave.setIn(['parameters', 'outputBucket'], common.getDefaultBucket(COMPONENT_ID, configId));
    }

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
    const existingIds = store.sheets.map((q) => q.get('id'));
    const randomNumber = () => Math.floor((Math.random() * 100000) + 1);
    let newId = randomNumber();
    while (existingIds.indexOf(newId) >= 0) {
      newId = randomNumber();
    }
    return newId;
  }

  function saveSheets(newSheets, savingPath, changeDescription) {
    const msg = changeDescription || 'Update sheets';
    const data = store.configData.setIn(['parameters', 'sheets'], newSheets);
    return saveConfigData(data, savingPath, msg);
  }

  return {

    prepareLocalState: prepareLocalState,
    updateLocalState: updateLocalState,

    onChangeEditingSheetFn(sheetId) {
      const path = store.getEditingSheetPath(sheetId);
      return (newSheet) => updateLocalState(path, newSheet);
    },

    onUpdateNewSheet(newSheet) {
      const path = store.getNewSheetPath();
      return updateLocalState(path, newSheet);
    },

    startEditingSheet(sheetId) {
      const path = store.getEditingSheetPath(sheetId);
      const sheet = store.getConfigSheet(sheetId);
      updateLocalState(path, sheet);
    },

    saveNewSheets(newSheets) {
      const sheetsToAdd = newSheets.map( (s) => {
        const name = `${s.get('fileTitle')}-${common.sanitizeTableName(s.get('sheetTitle'))}`;
        return s.set('enabled', true)
          .set('id', generateId())
          .set('outputTable', name);
      });
      const sheetsToSave = store.sheets.toSet().merge(sheetsToAdd);
      const data = store.configData.setIn(['parameters', 'sheets'], sheetsToSave);
      const savingPath = store.getSavingPath(['newSheets']);
      return saveConfigData(data, savingPath, `Add ${newSheets.count()} sheet(s)`);
    },

    cancelEditingNewSheet() {
      const path = store.getNewSheetPath();
      return updateLocalState(path, store.defaultNewSheet);
    },

    saveEditingSheet(sheet) {
      const sheetId = sheet.get('id').toString();
      const msg = `Update sheet ${sheet.get('sheetTitle')}`;
      const sheets = store.sheets.map((q) => q.get('id').toString() === sheetId ? sheet : q);
      const data = store.configData.setIn(['parameters', 'sheets'], sheets);
      const savingPath = store.getSavingPath(['updatingSheets']);
      return saveConfigData(data, savingPath, msg);
    },

    cancelEditingSheet(sheetId) {
      const path = store.getEditingSheetPath(sheetId);
      updateLocalState(path, null);
    },

    deleteSheet(sheetId) {
      const newSheets = store.sheets.filter((q) => q.get('id').toString() !== sheetId.toString());
      const msg = `Remove sheet ${store.getConfigSheet(sheetId).get('sheetTitle')}`;
      return saveSheets(newSheets, store.getPendingPath(['delete', sheetId]), msg);
    },

    toggleSheetEnabled(sheetId) {
      let newSheet = store.getConfigSheet(sheetId);
      const msg = `${newSheet.get('enabled') ? 'Disable' : 'Enable'} extraction of ${newSheet.get('sheetTitle')} sheet`;
      newSheet = newSheet.set('enabled', !newSheet.get('enabled'));
      const newSheets = store.sheets.map((q) => q.get('id').toString() === sheetId.toString() ? newSheet : q);
      return saveSheets(newSheets, store.getPendingPath(['toggle', sheetId]), msg);
    },

    setSheetsFilter(newFilter) {
      return updateLocalState('filter', newFilter);
    }

  };
}
