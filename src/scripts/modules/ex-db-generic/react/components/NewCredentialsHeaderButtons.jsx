import React from 'react';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import routesStore from '../../../../stores/RoutesStore';

import * as storeProvisioning from '../../storeProvisioning';
import * as actionsProvisioning from '../../actionsProvisioning';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import {Navigation} from 'react-router';

export default function(componentId) {
  const actionCreators = actionsProvisioning.createActions(componentId);
  return React.createClass({
    mixins: [createStoreMixin(storeProvisioning.componentsStore), Navigation],

    getStateFromStores() {
      const config = routesStore.getCurrentRouteParam('config');
      const dbStore = storeProvisioning.createStore(componentId, config);
      const isValid = dbStore.hasValidCredentials(dbStore.getNewCredentials(config), true);
      return {
        configId: config,
        isSaving: dbStore.isSavingCredentials(),
        isValid: isValid
      };
    },

    handleCancel() {
      this.goToIndex();
      actionCreators.resetNewCredentials(this.state.configId);
    },

    handleSave() {
      actionCreators
      .saveNewCredentials(this.state.configId)
      .then(() => this.goToIndex());
    },

    goToIndex() {
      this.transitionTo(`ex-db-generic-${componentId}`, {
        config: this.state.configId
      });
    },

    render() {
      return (
        <ConfirmButtons
          isSaving={ this.state.isSaving }
          onSave={ this.handleSave }
          onCancel={ this.handleCancel }
          isDisabled= {!this.state.isValid}
        />
      );
    }

  });
}
