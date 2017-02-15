import {fromJS, Map} from 'immutable';
import OauthActions from './ActionCreators';
import ApplicationStore from '../../stores/ApplicationStore';
import OauthStore from './Store';
import installedComponentsActions from '../components/InstalledComponentsActionCreators';
import installedComponentsStore from '../components/stores/InstalledComponentsStore';
import RouterStore from '../../stores/RoutesStore';
import ApplicationActionCreators from '../../actions/ApplicationActionCreators';
import StorageApi from '../components/StorageApi';
const configOauthPath = ['authorization', 'oauth_api', 'id'];

function processRedirectData(componentId, configId, id) {
  // config component configuration
  return installedComponentsActions.loadComponentConfigData(componentId, configId)
    .then( () => {
      const configuration = installedComponentsStore.getConfigData(componentId, configId) || Map();

      // load credentials for componentId and id
      return OauthActions.loadCredentials(componentId, id)
        .then(() => {
          const credentials = OauthStore.getCredentials(componentId, id);
          const newConfiguration = configuration.setIn(configOauthPath, id);

          // save configuration with authorization id
          const saveFn = installedComponentsActions.saveComponentConfigData;
          const authorizedFor = credentials.get('authorizedFor');
          return saveFn(componentId, configId, fromJS(newConfiguration), `Save authorization for ${authorizedFor}`).then(() => authorizedFor);
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

// create a router route that is redirection from oauth process
// counts on having configIf as config parameter in route params
// @routeName - redirection route name eg 'ex-dropbox-redirect'
// @redirectPathName - path to the route to redirect after success
// process eg. 'ex-dropbox-index'
// @redirectParamsFn - function takes params and returns params for
// redirection to @redirectPathName e.g (params) -> params.config
// @componentId - componentId
export function createRedirectRoute(routeName, redirectPathName, redirectParamsFn, componentId) {
  return {
    name: routeName,
    path: 'oauth-redirect',
    title: 'Authorizing...',
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
      }                                                        ]
  };
}

// simplified wrapper of createRedirectRoute(^^) that takes only componentId
// the route must accept config param - :config path in the parent route
export function createRedirectRouteSimple(componentId) {
  return createRedirectRoute(
    componentId + '-oauth-redirect',
    componentId,
    (params) => {
      return {
        component: componentId,
        config: params.config
      };
    },
    componentId
  );
}

// get credentials id from configData and load credentials
export function loadCredentialsFromConfig(componentId, configId) {
  const configuration = installedComponentsStore.getConfigData(componentId, configId);
  const id = configuration.getIn(configOauthPath);

  if (id) {
    return OauthActions.loadCredentials(componentId, id);
  }
}

// delete credentials and docker configuration object part
export function deleteCredentialsAndConfigAuth(componentId, configId) {
  const configData = installedComponentsStore.getConfigData(componentId, configId);
  const credentialsId = configData.getIn(configOauthPath);
  const credentials = OauthStore.getCredentials(componentId, credentialsId);
  const authorizedFor = credentials.get('authorizedFor');
  return OauthActions.deleteCredentials(componentId, credentialsId)
    .then(() => {
      // delete the whole authorization object part of the configuration
      const newConfigData = configData.deleteIn([].concat(configOauthPath[0]));
      const saveFn = installedComponentsActions.saveComponentConfigData;
      return saveFn(componentId, configId, newConfigData, `Reset authorization of ${authorizedFor}`);
    });
}

export function getCredentialsId(configData) {
  return configData.getIn(configOauthPath);
}

export function getCredentials(componentId, configId) {
  return OauthStore.getCredentials(componentId, configId);
}

export function generateLink(componentId, configId) {
  const description = ApplicationStore.getSapiToken().get('description');
  const tokenParams = {
    canManageBuckets: false,
    canReadAllFileUploads: false,
    componentAccess: [componentId],
    description: `${description} external oauth link`,
    expiresIn: (48 * 3600) // 48 hours in seconds
  };
  const externalAppUrl = 'https://external.keboola.com/oauth/index.html';
  return StorageApi.createToken(tokenParams)
    .then((token) => {
      return `${externalAppUrl}?token=${token.token}&sapiUrl=${ApplicationStore.getSapiUrl()}#/${componentId}/${configId}`;
    });
}
