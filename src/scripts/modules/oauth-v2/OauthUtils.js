import {fromJS, Map} from 'immutable';
import OauthActions from './ActionCreators';
import OauthStore from './Store';

import installedComponentsActions from '../components/InstalledComponentsActionCreators';
import installedComponentsStore from '../components/stores/InstalledComponentsStore';
import RouterStore from '../../stores/RoutesStore';
import ApplicationActionCreators from '../../actions/ApplicationActionCreators';

const configOauthPath = ['authorization', 'oauth_api', 'id'];

function processRedirectData(componentId, configId, id) {
  // config component configuration
  return installedComponentsActions.loadComponentConfigData(componentId, configId)
    .then( () => {
      const configuration = installedComponentsStore.getConfigData(componentId, configId) || Map();
      console.log(configuration.toJS());

      // load credentials for componentId and id
      return OauthActions.loadCredentials(componentId, id)
        .then(() => {
          const credentials = OauthStore.getCredentials(componentId, id);
          console.log('KREDENCE', credentials.toJS());
          const newConfiguration = configuration.setIn(configOauthPath, id);

          // save configuration with authorization id
          const saveFn = installedComponentsActions.saveComponentConfigData;
          const authorizedFor = credentials.get('authorizedFor');
          return saveFn(componentId, configId, fromJS(newConfiguration)).then(() => authorizedFor);
        });
    });
}

function redirectToPath(path, params) {
  const router = RouterStore.getRouter();
  router.transitionTo(path, params);
}

function sendNotification(message, type = 'success') {
  const notification = {
    message: message,
    type: type
  };
  ApplicationActionCreators.sendNotification(notification);
}

export function createRedirectRoute(routeName, redirectPathName, redirectParamsFn, componentId) {
  return {
    name: routeName,
    path: 'oauth-redirect',
    title: 'redirect pico',
    requireData: [
      (params) => {
        const configId = params.config;
        const cid = componentId || params.component;
        processRedirectData(cid, configId, configId)
          .then((authorizedFor) => {
            const msg = `Account succesfully authorized for ${authorizedFor}`;
            sendNotification(msg);
            redirectToPath(redirectPathName, redirectParamsFn(params));
          });
      }
    ]
  };
}
