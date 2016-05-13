import React from 'react';
import Credentials from './Credentials';
import createStoreMixin from '../../../../../react/mixins/createStoreMixin';
import routesStore from '../../../../../stores/RoutesStore';

import * as storeProvisioning from '../../../storeProvisioning';
import * as actionsProvisioning from '../../../actionsProvisioning';

export default function(componentId) {
  const actionCreators = actionsProvisioning.createActions(componentId);
  return React.createClass({
    mixins: [createStoreMixin(storeProvisioning.componentsStore)],

    getStateFromStores() {
      const config = routesStore.getCurrentRouteParam('config');
      const dbStore = storeProvisioning.createStore(componentId, config);
      return {
        configurationId: config,
        credentials: dbStore.getNewCredentials(),
        isSaving: dbStore.isSavingCredentials()
      };
    },

    render() {
      return (
        <Credentials
          credentials={ this.state.credentials }
          isEditing={ !this.state.isSaving }
          onChange={ this.handleChange }
          componentId={componentId}
        />
      );
    },

    handleChange(newCredentials) {
      actionCreators.updateNewCredentials(this.state.configurationId, newCredentials);
    }

  });
}
