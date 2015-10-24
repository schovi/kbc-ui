//import actions from '../../components/InstalledComponentsActionCreators';
import oAuthActions from '../../components/OAuthActionCreators';
//import store from '../../components/stores/InstalledComponentsStore';

const COMPONENT_ID = 'ex-dropbox';

export function deleteCredentials(configId) {
  oAuthActions.deleteCredentials(COMPONENT_ID, configId);
}