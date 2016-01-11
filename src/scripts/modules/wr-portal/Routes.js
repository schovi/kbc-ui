import installedComponentsActions from '../components/InstalledComponentsActionCreators';
import Index from './react/Index';

const componentId = 'wr-portal-sas';
export default {
  name: componentId,
  path: ':config',
  isComponent: true,
  defaultRouteHandler: Index,
  requireData: [
    (params) => installedComponentsActions.loadComponentConfigData(componentId, params.config)
  ]

};
