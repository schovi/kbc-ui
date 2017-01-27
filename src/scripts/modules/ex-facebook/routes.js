import Index from './react/Index';
import installedComponentsActions from '../components/InstalledComponentsActionCreators';
// import HeaderButtons from './react/HeaderButtons';
import storageActions from '../components/StorageActionCreators';
import jobsActionCreators from '../jobs/ActionCreators';
import versionsActions from '../components/VersionsActionCreators';
import * as oauthUtils from '../oauth-v2/OauthUtils';

const componentId = 'keboola.ex-facebook';

export default {
  name: componentId,
  path: ':config',
  isComponent: true,
  defaultRouteHandler: Index,
  requireData: [
    (params) => installedComponentsActions.loadComponentConfigData(componentId, params.config).then(() => {
      return oauthUtils.loadCredentialsFromConfig(componentId, params.config);
    }),
    () => storageActions.loadTables(),
    (params) => versionsActions.loadVersions(componentId, params.config)
  ],
  poll: {
    interval: 5,
    action: (params) => jobsActionCreators.loadComponentConfigurationLatestJobs(componentId, params.config)
  }
};
