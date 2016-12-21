import installedComponentsActions from '../components/InstalledComponentsActionCreators';
import {Map} from 'immutable';
import CreateIndexFn from './react/Index';
import storageActions from '../components/StorageActionCreators';
import InstalledComponentStore from '../components/stores/InstalledComponentsStore';

// const componentId = 'wr-portal-sas';

export default function(componentId) {
  return {
    name: componentId,
    path: ':config',
    isComponent: true,
    defaultRouteHandler: CreateIndexFn(componentId),
    requireData: [
      (params) => {
        installedComponentsActions
          .loadComponentConfigData(componentId, params.config)
          .then(() => {
            const configData = InstalledComponentStore.getConfigData(componentId, params.config) || Map();
            const bucketId = configData.get('bucketId');

            return bucketId && storageActions.loadCredentials(bucketId);
          });
      },
      () => storageActions.loadTables()
    ]

  };
}
