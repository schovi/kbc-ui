import React from 'react';
import Credentials from './Credentials';
import createStoreMixin from '../../../../../react/mixins/createStoreMixin';
import routesStore from '../../../../../stores/RoutesStore';

export default function(componentId, actionsProvisioning, storeProvisioning, credentialsTemplate, hasSshTunnel) {
  const actionCreators = actionsProvisioning.createActions(componentId);
  return React.createClass({
    mixins: [createStoreMixin(storeProvisioning.componentsStore)],

    getStateFromStores() {
      const config = routesStore.getCurrentRouteParam('config');
      const dbStore = storeProvisioning.createStore(componentId, config);
      return {
        configId: config,
        credentials: dbStore.getCredentials(),
        isEditing: dbStore.isEditingCredentials(),
        editingCredentials: dbStore.getEditingCredentials(),
        isSaving: dbStore.isSavingCredentials()
      };
    },

    render() {
      return (
        <Credentials
          configId={this.state.configId}
          credentials={ this.getCredentials() }
          isEditing={ this.state.isEditing && !this.state.isSaving }
          onChange={ this.handleChange }
          componentId={componentId}
          credentialsTemplate={credentialsTemplate}
          hasSshTunnel={hasSshTunnel}
        />
      );
    },

    handleChange(newCredentials) {
      actionCreators.updateEditingCredentials(this.state.configId, newCredentials);
    },

    getCredentials() {
      return this.state.isEditing ? this.state.editingCredentials : this.state.credentials;
    }
  });
}
