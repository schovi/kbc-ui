import Index from './react/Index/Index';
import storageActions from '../components/StorageActionCreators';
import InstalledComponentsStore from '../components/stores/InstalledComponentsStore';
import installedComponentsActions from '../components/InstalledComponentsActionCreators';

const COMPONENT_ID = 'keboola.csv-import';

export default {
  name: COMPONENT_ID + '-config',
  path: ':config',
  isComponent: true,
  defaultRouteHandler: Index,
  title: (routerState) => {
    const configId = routerState.getIn(['params', 'config']);
    return InstalledComponentsStore.getConfig(COMPONENT_ID, configId).get('name');
  },
  requireData: [
    (params) => installedComponentsActions.loadComponentConfigData(COMPONENT_ID, params.config),
    () => storageActions.loadTables()
  ]
};
