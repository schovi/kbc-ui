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
    queries: parameters.getIn(['queries'])
  };
}
