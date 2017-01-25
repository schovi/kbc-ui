import {Map, List} from 'immutable';
import InstalledComponentStore from '../components/stores/InstalledComponentsStore';
import _ from 'underscore';
import OauthStore from '../oauth-v2/Store';


export const storeMixins = [InstalledComponentStore, OauthStore];

const COMPONENT_ID = 'keboola.ex-facebook';
const DEFAULT_API_VERSION = 'v2.8';

export default function(configId) {
  const localState = () => InstalledComponentStore.getLocalState(COMPONENT_ID, configId) || Map();
  const configData =  InstalledComponentStore.getConfigData(COMPONENT_ID, configId) || Map();
  const oauthCredentialsId = configData.getIn(['authorization', 'oauth_api', 'id'], configId);
  const parameters = configData.get('parameters', Map());
  const tempPath = ['_'];
  const syncAccountsPath = tempPath.concat('SyncAccounts');

  // ----ACTUAL STATE OBJECT------
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
    syncAccountsPath: syncAccountsPath,
    syncAccounts: localState().getIn(syncAccountsPath, Map()),
    configData: configData,
    parameters: parameters,
    queries: parameters.get('queries', List()),
    version: parameters.get('api-version', DEFAULT_API_VERSION),
    accounts: parameters.get('accounts'),
    isAuthorized() {
      const creds = this.oauthCredentials;
      return creds && creds.has('id');
    }
  };
}
