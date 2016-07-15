import Index from './react/Index/Index';
import storageActions from '../components/StorageActionCreators';
import IntalledComponentsStore from '../components/stores/InstalledComponentsStore';

const COMPONENT_ID = 'keboola.csv-import';

export default {
  name: COMPONENT_ID + '-config',
  path: ':config',
  isComponent: true,
  defaultRouteHandler: Index,
  title: (routerState) => {
    const configId = routerState.getIn(['params', 'config']);
    return IntalledComponentsStore.getConfig(COMPONENT_ID, configId).get('name');
  },
  requireData: [
    () => storageActions.loadTables()
  ]
};
