import React from 'react';

import createStoreMixin from '../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../stores/RoutesStore';
import InstalledComponentStore from '../../components/stores/InstalledComponentsStore';
/* import LatestJobsStore from '../../jobs/stores/LatestJobsStore'; */
/* import storageTablesStore from '../../components/stores/StorageTablesStore'; */

const componentId = 'wr-portal-sas';

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    const localState = InstalledComponentStore.getLocalState(componentId, configId);
    const configData = InstalledComponentStore.getConfigData(componentId, configId);

    return {
      configId: configId,
      localState: localState,
      configData: configData
    };
  },

  render() {
    return (
      <div> No se que </div>
    );
  }

});
