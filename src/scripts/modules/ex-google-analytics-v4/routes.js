import Index from './react/Index/Index';
import * as oauthUtils from '../oauth-v2/OauthUtils';
import installedComponentsActions from '../components/InstalledComponentsActionCreators';
// import HeaderButtons from './react/HeaderButtons';
import storageActions from '../components/StorageActionCreators';
// import jobsActionCreators from '../jobs/ActionCreators';

const COMPONENT_ID = 'keboola.ex-google-analytics-v4';

export default {
  name: COMPONENT_ID,
  path: ':config',
  isComponent: true,
  defaultRouteHandler: Index,
  // headerButtonsHandler: HeaderButtons,
  requireData: [
    (params) => installedComponentsActions.loadComponentConfigData(COMPONENT_ID, params.config),
    () => storageActions.loadTables()
  ],
  childRoutes: [
    oauthUtils.createRedirectRouteSimple(COMPONENT_ID)
  ]

  // ,
  // poll: {
  //   interval: 5,
  //   action: (params) => jobsActionCreators.loadComponentConfigurationLatestJobs(COMPONENT_ID, params.config)
  // }
};
