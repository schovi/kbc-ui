import {List, Map} from 'immutable';
import fuzzy from 'fuzzy';

import {getDefaultBucket} from './common';
import _ from 'underscore';
import InstalledComponentStore from '../components/stores/InstalledComponentsStore';
import OauthStore from '../oauth-v2/Store';

const COMPONENT_ID = 'keboola.ex-google-drive';

const defaultNewSheet = Map({
  id: null,
  fileId: null,
  fileTitle: null,
  sheetId: null,
  sheetTitle: null,
  enabled: true,
  outputTable: null
});

export const storeMixins = [InstalledComponentStore, OauthStore];

export default function(configId) {
  const localState = () => InstalledComponentStore.getLocalState(COMPONENT_ID, configId) || Map();
  const configData =  InstalledComponentStore.getConfigData(COMPONENT_ID, configId) || Map();
  const oauthCredentialsId = configData.getIn(['authorization', 'oauth_api', 'id'], configId);

  const parameters = configData.get('parameters', Map());
  const sheets = parameters.getIn(['sheets'], List());

  const tempPath = ['_'];
  const savingPath = tempPath.concat('saving');
  const editingSheetsPath = tempPath.concat('editingSheets');
  const newSheetPath = tempPath.concat('newSheet');
  const pendingPath = tempPath.concat('pending');
  const defaultOutputBucket = getDefaultBucket(COMPONENT_ID, configId);
  const outputBucket = parameters.get('outputBucket') || defaultOutputBucket;

  const filter = localState().get('filter', '');
  const sheetsFiltered = sheets.filter((q) => {
    return fuzzy.match(filter, q.get('sheetTitle'));
  });

  function getConfigSheet(sheetId) {
    return sheets.find((q) => q.get('id').toString() === sheetId.toString());
  }

  return {
    oauthCredentials: OauthStore.getCredentials(COMPONENT_ID, oauthCredentialsId) || Map(),
    oauthCredentialsId: oauthCredentialsId,

    // local state stuff
    getLocalState(path) {
      if (_.isEmpty(path)) {
        return localState() || Map();
      }
      return localState().getIn([].concat(path), Map());
    },

    // config data stuff
    sheets: sheets,
    profiles: parameters.getIn(['profiles'], List()),
    configData: configData,
    outputBucket: outputBucket,
    defaultNewSheet: defaultNewSheet,
    filter: filter,
    sheetsFiltered: sheetsFiltered,
    hasCredentials: !!oauthCredentialsId,


    isSaving(what) {
      return localState().getIn(savingPath.concat(what), false);
    },

    isSavingSheet(sheetId) {
      return localState().getIn(this.getSavingPath(['sheets', sheetId]), false);
    },

    isSheetValid(sheet) {
      return !!sheet.get('outputTable');
    },

    getSavingPath(what) {
      return savingPath.concat(what);
    },
    getConfigSheet: getConfigSheet,

    getNewSheetPath() {
      return newSheetPath;
    },

    getNewSheet() {
      return localState().getIn(newSheetPath, defaultNewSheet);
    },

    getEditingSheetPath(sheetId) {
      return editingSheetsPath.concat(sheetId);
    },

    getEditingSheet(sheetId) {
      return localState().getIn(this.getEditingSheetPath(sheetId), null);
    },

    getPendingPath(what) {
      return pendingPath.concat(what);
    },

    isPending(what) {
      return localState().getIn(pendingPath.concat(what), null);
    },

    getRunSingleSheetData(sheetId) {
      const sheet = getConfigSheet(sheetId).set('enabled', true);
      return configData.setIn(['parameters', 'sheets'], List().push(sheet)).toJS();
    },

    isAuthorized() {
      const creds = this.oauthCredentials;
      return creds && creds.has('id');
    }

  };
}
