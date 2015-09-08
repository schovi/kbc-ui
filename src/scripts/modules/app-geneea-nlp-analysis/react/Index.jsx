import React from 'react';

import createStoreMixin from '../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../stores/RoutesStore';
import InstalledComponentStore from '../../components/stores/InstalledComponentsStore';
import ComponentStore from '../../components/stores/ComponentsStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';

//import EmptyState from '../../components/react/components/ComponentEmptyState';
//import ComponentDescription from '../../components/react/components/ComponentDescription';
//import ComponentMetadata from '../../components/react/components/ComponentMetadata';
//import RunComponentButton from '../../components/react/components/RunComponentButton';
//import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';
//import LatestJobs from '../../components/react/components/SidebarJobs';


export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, LatestJobsStore, ComponentStore)],

  getStateFromStores(){
    const configId = RoutesStore.getCurrentRouteParam('config');
    return {
      configId: configId
    };
  },


  render(){
    return (<div> INDEX </div>);
  }


});
