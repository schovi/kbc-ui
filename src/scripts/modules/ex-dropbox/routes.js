import Index from './react/Index';
import installedComponentsActions from '../components/InstalledComponentsActionCreators';
import installedComponentsStore from '../components/stores/InstalledComponentsStore';
import jobsActionCreators from '../jobs/ActionCreators';
import oauthStore from '../components/stores/OAuthStore';
import oauthActions from '../components/OAuthActionCreators';
import Immutable from 'immutable';
import RouterStore from '../../stores/RoutesStore';
import ApplicationActionCreators from '../../actions/ApplicationActionCreators';


export default {
  name: 'ex-dropbox',
  path: 'ex-dropbox/:config',
  isComponent: true,
  requireData: [
    (params) => installedComponentsActions.loadComponentConfigData('ex-dropbox', params.config),
    (params) => oauthActions.loadCredentials('ex-dropbox', params.config)
  ],
  poll: {
    interval: 7,
    action: (params) => jobsActionCreators.loadComponentConfigurationLatestJobs('ex-dropbox', params.config)
  },
  defaultRouteHandler: Index,

  childRoutes: [
    {
      name: 'ex-dropbox-oauth-redirect',
      path: 'oauth-redirect',
      title: '',
      requireData: [
        (params) => installedComponentsActions.loadComponentConfigData('ex-dropbox', params.config).then(() => {
          let configuration = installedComponentsStore.getConfigData('ex-dropbox', params.config).toJS();
          return oauthActions.loadCredentials('ex-dropbox', params.config).then(() => {
            let credentials = oauthStore.getCredentials('ex-dropbox', params.config).toJS();
            let parameters = configuration ? configuration.parameters : {};
            parameters.credentials = params.config;
            configuration.parameters = parameters;
            let description = credentials ? credentials.description : '';
            let saveFn = installedComponentsActions.saveComponentConfigData;
            return saveFn('ex-dropbox', params.config, Immutable.fromJS(configuration)).then(() => {
              let router = RouterStore.getRouter();
              let notification = `Dropbox account ${description} successfully authorized.`;
              ApplicationActionCreators.sendNotification({
                message: notification
              });
              return router.transitionTo('ex-dropbox', {config: params.config});
            });
          }, (error) => {
            let router = RouterStore.getRouter();
            let notification = `Failed to authorize the Dropbox account, error: ${error}, please contact us on support@keboola.com`;
            ApplicationActionCreators.sendNotification({
              message: notification,
              type: 'error'
            });
            return router.transitionTo('ex-dropbox', {config: params.config});
          });
        })
      ]
    }
  ]
};