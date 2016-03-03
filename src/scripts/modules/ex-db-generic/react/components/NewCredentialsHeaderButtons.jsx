import React from 'react';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import routesStore from '../../../../stores/RoutesStore';

import * as storeProvisioning from '../../storeProvisioning';
import * as actionsProvisioning from '../../actionsProvisioning';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import {Navigation} from 'react-router';

const componentId = 'keboola.ex-db-pgsql';
const actionCreators = actionsProvisioning.createActions(componentId);

export default React.createClass({
  mixins: [createStoreMixin(storeProvisioning.store), Navigation],

  getStateFromStores() {
    const config = routesStore.getCurrentRouteParam('config');
    const dbStore = storeProvisioning.createStore(componentId, config);
    return {
      configId: config,
      isSaving: dbStore.isSavingCredentials()
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
    this.transitionTo(componentId, {
      config: this.state.configId
    });
  },

  render() {
    return (
      <ConfirmButtons
          isSaving={ this.state.isSaving }
          onSave={ this.handleSave }
          onCancel={ this.handleCancel }
        />
    );
  }

});
