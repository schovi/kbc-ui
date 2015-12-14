import Index from './react/Index';
import installedComponentsActions from '../components/InstalledComponentsActionCreators';
import jobsActionCreators from '../jobs/ActionCreators';
import oauthStore from '../components/stores/OAuthStore';
import oauthActions from '../components/OAuthActionCreators';
import RouterStore from '../../stores/RoutesStore';
import ApplicationActionCreators from '../../actions/ApplicationActionCreators';


export default {
  name: 'ex-dropbox',
  path: ':config',
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
          return oauthActions.loadCredentials('ex-dropbox', params.config).then(() => {
            let credentials = oauthStore.getCredentials('ex-dropbox', params.config);
            let notification = `Dropbox account ${credentials.get('description')} successfully authorized.`;
            let router = RouterStore.getRouter();
            ApplicationActionCreators.sendNotification({
              message: notification
            });
            return router.transitionTo('ex-dropbox', {config: params.config});
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