import Index from './react/Index/Index';
import QueryDetail from './react/QueryDetail/QueryDetail';
import NewQuery from './react/NewQuery/NewQuery';
import * as oauthUtils from '../oauth-v2/OauthUtils';
import installedComponentsActions from '../components/InstalledComponentsActionCreators';
// import HeaderButtons from './react/HeaderButtons';
import storageActions from '../components/StorageActionCreators';
// import jobsActionCreators from '../jobs/ActionCreators';

import store from './storeProvisioning';
import IntalledComponentsStore from '../components/stores/InstalledComponentsStore';

const COMPONENT_ID = 'keboola.ex-google-analytics-v4';

export default {
  name: COMPONENT_ID,
  path: ':config',
  isComponent: true,
  defaultRouteHandler: Index,
  title: (routerState) => {
    const configId = routerState.getIn(['params', 'config']);
    return IntalledComponentsStore.getConfig(COMPONENT_ID, configId).get('name');
  },
  // headerButtonsHandler: HeaderButtons,
  requireData: [
    (params) => installedComponentsActions.loadComponentConfigData(COMPONENT_ID, params.config).then(() => {
      return oauthUtils.loadCredentialsFromConfig(COMPONENT_ID, params.config);
    }),
    () => storageActions.loadTables()
  ],
  childRoutes: [
    oauthUtils.createRedirectRouteSimple(COMPONENT_ID),
    {
      name: COMPONENT_ID + '-query-detail',
      path: 'query/:queryId',
      handler: QueryDetail,
      title: (routerState) => {
        const configId = routerState.getIn(['params', 'config']);
        const queryId = routerState.getIn(['params', 'queryId']);
        return store(configId).getConfigQuery(queryId).get('name');
      }
    },
    {
      name: COMPONENT_ID + '-new-query',
      path: 'new-query',
      handler: NewQuery,
      title: () => 'New Query'
    }
  ]

  // ,
  // poll: {
  //   interval: 5,
  //   action: (params) => jobsActionCreators.loadComponentConfigurationLatestJobs(COMPONENT_ID, params.config)
  // }
};
