import {List, Map} from 'immutable';
import {getDefaultBucket} from './common';
import _ from 'underscore';
import InstalledComponentStore from '../components/stores/InstalledComponentsStore';
import OauthStore from '../oauth-v2/Store';

const COMPONENT_ID = 'keboola.ex-google-analytics-v4';

const defaultNewQuery = Map({
  name: '',
  enabled: true,
  outputTable: null,
  query: Map({
    dateRanges: List([Map({
      startDate: '-4 days',
      endDate: 'now'
    })])
  })
});

export const storeMixins = [InstalledComponentStore, OauthStore];

export default function(configId) {
  const localState = InstalledComponentStore.getLocalState(COMPONENT_ID, configId) || Map();
  const configData =  InstalledComponentStore.getConfigData(COMPONENT_ID, configId) || Map();
  const oauthCredentialsId = configData.getIn(['authorization', 'oauth_api', 'id'], configId);

  const parameters = configData.get('parameters', Map());
  const queries = parameters.getIn(['queries'], List());

  const tempPath = ['_'];
  const savingPath = tempPath.concat('saving');
  const editingQueriesPath = tempPath.concat('editingQueries');
  const newQueryPath = tempPath.concat('newQuery');

  const defaultOutputBucket = getDefaultBucket(COMPONENT_ID, configId);
  const outputBucket = parameters.get('outputBucket') || defaultOutputBucket;

  return {
    oauthCredentials: OauthStore.getCredentials(COMPONENT_ID, oauthCredentialsId),
    oauthCredentialsId: oauthCredentialsId,

    // local state stuff
    getLocalState(path) {
      if (_.isEmpty(path)) {
        return localState || Map();
      }
      return localState.getIn([].concat(path), Map());
    },

    // config data stuff
    queries: queries,
    profiles: parameters.getIn(['profiles']),
    configData: configData,
    outputBucket: outputBucket,
    isSaving(what) {
      return localState.getIn(savingPath.concat(what), false);
    },
    getSavingPath(what) {
      return savingPath.concat(what);
    },
    getConfigQuery(queryId) {
      return queries.find((q) => q.get('id').toString() === queryId.toString());
    },

    getNewQueryPath() {
      return newQueryPath;
    },

    getNewQuery() {
      return localState.getIn(newQueryPath, defaultNewQuery);
    },

    getEditingQueryPath(queryId) {
      return editingQueriesPath.concat(queryId);
    },

    getEditingQuery(queryId) {
      return localState.getIn(this.getEditingQueryPath(queryId), null);
    }
  };
}
