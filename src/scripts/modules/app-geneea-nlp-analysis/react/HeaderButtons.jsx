import React from 'react';

import * as actions from '../actions';

import createStoreMixin from '../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../stores/RoutesStore';
import InstalledComponentStore from '../../components/stores/InstalledComponentsStore';

import EditButtons from '../../../react/common/EditButtons';

const componentId = 'geneea-nlp-analysis';

export default React.createClass({

  mixins: [createStoreMixin(InstalledComponentStore)],
  getStateFromStores(){
    const configId = RoutesStore.getCurrentRouteParam('config');
    const localState = InstalledComponentStore.getLocalState(componentId, configId);
    //const configData = InstalledComponentStore.getConfigData(componentId, configId);

    return {
      localState: localState,
      editing: localState.get('editing'),
      configId: configId,
      isSaving: InstalledComponentStore.getSavingConfigData(componentId, configId)
    };
  },

  render(){
    return (
      <EditButtons
         editLabel="Setup"
         isEditing={this.state.editing}
         isSaving={this.state.isSaving}
         isDisabled={false}
         onCancel={ () => actions.cancel(this.state.configId)}
         onSave={ () => actions.save(this.state.configId)}
         onEditStart={ () => actions.startEditing(this.state.configId)}/>
      );
  }




  /* updateEditing(data){
     this.updateLocalState(['editing'], data);
     },

     updateLocalState(path, data){
     actions.updateLocalState(this.state.configId, path, data);
     } */

});
