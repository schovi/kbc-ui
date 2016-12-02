import storeProvisioning from './storeProvisioning';
import {Map} from 'immutable';
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
const getFullName = common.sheetFullName;

export default function(configId) {
  const store = storeProvisioning(configId);

  function updateLocalState(path, data) {
    const ls = store.getLocalState();
    const newLocalState = ls.setIn([].concat(path), data);
    componentsActions.updateLocalState(COMPONENT_ID, configId, newLocalState, path);
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

  function createProcessorConfig(sheet) {
    return (new Map())
      .set('definition', 'keboola.processor.transpose')
      .setIn(['parameters', 'filename'], `${sheet.get('fileId')}_${sheet.get('sheetId')}.csv`)
      .setIn(['parameters', 'header_rows_count'], sheet.getIn(['processor', 'headerRow']))
      .setIn(['parameters', 'header_column_names'], sheet.getIn(['processor', 'headerColumnNames']))
      .setIn(['parameters', 'header_transpose_row'], sheet.getIn(['processor', 'transposeHeaderRow']))
      .setIn(['parameters', 'header_transpose_column_name'], sheet.getIn(['processor', 'transposedHeaderColumnName']))
      .setIn(['parameters', 'transpose_from_column'], sheet.getIn(['processor', 'transposeFrom']))
    ;
  }

  return {

    prepareLocalState: prepareLocalState,
    updateLocalState: updateLocalState,

    saveNewSheets(newSheets) {
      const sheetsToAdd = newSheets.map((s) => {
        const name = common.sanitizeTableName(getFullName(s, '-'));
        return s
          .set('id', generateId())
          .set('enabled', true)
          .setIn(['header', 'rows'], 1)
          .set('outputTable', name);
      });

      const sheetsToSave = store.sheets.toSet().merge(sheetsToAdd);
      const data = store.configData.setIn(['parameters', 'sheets'], sheetsToSave);
      const savingPath = store.getSavingPath(['newSheets']);
      const plural = newSheets.count() > 1 ? 's' : '';
      return saveConfigData(data, savingPath, `Add ${newSheets.count()} sheet${plural}`);
    },

    saveEditingSheet(sheet) {
      const sheetId = sheet.get('id').toString();
      const msg = `Update ${getFullName(sheet)}`;

      const dirtySheet = (new Map())
        .set('id', sheet.get('id'))
        .set('fileId', sheet.get('fileId'))
        .set('fileTitle', sheet.get('fileTitle'))
        .set('sheetId', sheet.get('sheetId'))
        .set('sheetTitle', sheet.get('sheetTitle'))
        .set('enabled', true)
        .setIn(['header', 'rows'], 1)
        .set('outputTable', name)
      ;
      const sheets = store.sheets.map((q) => q.get('id').toString() === sheetId ? dirtySheet : q);

      const processor = createProcessorConfig(sheet);

      const processors = store.processors.map(function(p) {
        return `${sheet.get('fileId')}_${sheet.get('sheetId')}.csv` === p.get('filename') ? processor : p;
      });

      const data = store.configData
        .setIn(['parameters', 'sheets'], sheets)
        .setIn(['processors', 'after'], processors)
      ;
      const savingPath = store.getSavingPath(['updatingSheets']);
      return saveConfigData(data, savingPath, msg);
    },

    deleteSheet(sheetId) {
      const newSheets = store.sheets.filter((q) => q.get('id').toString() !== sheetId.toString());
      const msg = `Remove ${getFullName(store.getConfigSheet(sheetId))}`;
      return saveSheets(newSheets, store.getPendingPath(['delete', sheetId]), msg);
    },

    toggleSheetEnabled(sheetId) {
      let newSheet = store.getConfigSheet(sheetId);
      const msg = `${newSheet.get('enabled') ? 'Disable' : 'Enable'} extraction of ${getFullName(newSheet)}`;
      newSheet = newSheet.set('enabled', !newSheet.get('enabled'));
      const newSheets = store.sheets.map((q) => q.get('id').toString() === sheetId.toString() ? newSheet : q);
      return saveSheets(newSheets, store.getPendingPath(['toggle', sheetId]), msg);
    }
  };
}
