import {Map} from 'immutable';
import _ from 'underscore';
import InstalledComponentStore from '../components/stores/InstalledComponentsStore';
import OauthStore from '../oauth-v2/Store';

const COMPONENT_ID = 'keboola.ex-google-analytics-v4';

export const storeMixins = [InstalledComponentStore, OauthStore];

export default function(configId) {
  const localState = InstalledComponentStore.getLocalState(COMPONENT_ID, configId) || Map();
  const configData =  InstalledComponentStore.getConfigData(COMPONENT_ID, configId) || Map();
  const oauthCredentialsId = configData.getIn(['authorization', 'oauth_api', 'id'], configId);

  const parameters = configData.get('parameters', Map());

  const tempPath = ['_'];
  const savingPath = tempPath.concat('saving');

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
    queries: parameters.getIn(['queries']),
    profiles: parameters.getIn(['profiles']),
    configData: configData,
    isSaving(what) {
      return localState.getIn(savingPath.concat(what), false);
    },
    getSavingPath(what) {
      return savingPath.concat(what);
    }
  };
}
