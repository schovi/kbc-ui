import Index from './react/Index';
import installedComponentsActions from '../components/InstalledComponentsActionCreators';
import jobsActionCreators from '../jobs/ActionCreators';

export default {
  name: 'ex-adform',
  path: ':config',
  isComponent: true,
  requireData: [
    (params) => installedComponentsActions.loadComponentConfigData('ex-adform', params.config)
  ],
  poll: {
    interval: 5,
    action: (params) => jobsActionCreators.loadComponentConfigurationLatestJobs('ex-adform', params.config)
  },
  defaultRouteHandler: Index
};