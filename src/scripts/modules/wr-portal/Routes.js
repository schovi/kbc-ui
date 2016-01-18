import installedComponentsActions from '../components/InstalledComponentsActionCreators';
import {Map} from 'immutable';
import Index from './react/Index';
import storageActions from '../components/StorageActionCreators';
import InstalledComponentStore from '../components/stores/InstalledComponentsStore';

const componentId = 'wr-portal-sas';
export default {
  name: componentId,
  path: ':config',
  isComponent: true,
  defaultRouteHandler: Index,
  requireData: [
    (params) => {
      installedComponentsActions.loadComponentConfigData(componentId, params.config).then(() => {
        const configData = InstalledComponentStore.getConfigData(componentId, params.config) || Map();
        const bucketId = configData.get('bucketId');
        if (bucketId) {
          return storageActions.loadCredentials(bucketId);
        }
      });
    },
    () => storageActions.loadTables()
  ]

};
