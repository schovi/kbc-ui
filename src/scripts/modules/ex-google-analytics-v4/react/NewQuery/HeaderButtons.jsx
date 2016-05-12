import React from 'react';
import {Navigation} from 'react-router';

// stores
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import storeProvisioning, {storeMixins} from '../../storeProvisioning';
import RoutesStore from '../../../../stores/RoutesStore';

// actions
import actionsProvisioning from '../../actionsProvisioning';

// ui components
import EditButtons from '../../../../react/common/EditButtons';

const COMPONENT_ID = 'keboola.ex-google-analytics-v4';

export default React.createClass({

  mixins: [createStoreMixin(...storeMixins), Navigation],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    const store = storeProvisioning(configId);
    const actions = actionsProvisioning(configId);
    const newQuery = store.getNewQuery();

    return {
      configId: configId,
      newQuery: newQuery,
      store: store,
      actions: actions
    };
  },

  render() {
    const {actions} = this.state;
    return (
      <EditButtons
        isEditing={true}
        isSaving={this.state.store.isSaving('newQuery')}
        isDisabled={!this.state.store.isQueryValid(this.state.newQuery)}
        onCancel={ () => actions.cancelEditingNewQuery()}
        onSave={ () => this.save()}
        onEditStart={() => {}}
      />
    );
  },

  save() {
    return this.state.actions.saveNewQuery().then( () => {
      this.transitionTo(COMPONENT_ID, {config: this.state.configId});
      return this.state.actions.cancelEditingNewQuery();
    });
  }
});
