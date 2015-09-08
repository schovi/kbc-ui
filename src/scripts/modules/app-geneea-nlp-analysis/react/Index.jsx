import React from 'react';

import installedComponentsActions from '../../components/InstalledComponentsActionCreators';

import createStoreMixin from '../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../stores/RoutesStore';
import InstalledComponentStore from '../../components/stores/InstalledComponentsStore';
import ComponentStore from '../../components/stores/ComponentsStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';

//import EmptyState from '../../components/react/components/ComponentEmptyState';
import ComponentDescription from '../../components/react/components/ComponentDescription';
//import ComponentMetadata from '../../components/react/components/ComponentMetadata';
//import RunComponentButton from '../../components/react/components/RunComponentButton';
//import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';
//import LatestJobs from '../../components/react/components/SidebarJobs';

const componentId = 'geneea-nlp-analysis';

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, LatestJobsStore, ComponentStore)],

  getStateFromStores(){
    const configId = RoutesStore.getCurrentRouteParam('config');
    const localState = InstalledComponentStore.getLocalState(componentId, configId);

    return {
      configId: configId,
      localState: localState
    };
  },


  render(){
    return (
      <div className="container-fluid">
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <ComponentDescription
              componentId={componentId}
              configId={this.state.configId}
              />
          </div>
          <div className="row">
            <div className="col-xs-4">
              <div>
                main content
              </div>
            </div>
          </div>
        </div>
      </div>

    );
  },

  updateLocalState(path, data){
    const newState = this.state.localState.setIn(path, data);
    installedComponentsActions.updateLocalState(componentId, this.state.configId, newState);

  }

});
