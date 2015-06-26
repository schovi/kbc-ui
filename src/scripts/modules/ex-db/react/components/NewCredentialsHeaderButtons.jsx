import React from 'react';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import routesStore from '../../../../stores/RoutesStore';
import dbStore from '../../exDbStore';
import actionCreators from '../../exDbActionCreators';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import {Navigation} from 'react-router';

export default React.createClass({
  mixins: [createStoreMixin(dbStore), Navigation],

  getStateFromStores() {
    const config = routesStore.getCurrentRouteParam('config');
    return {
      configId: config,
      isSaving: dbStore.isSavingCredentials(config)
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
    this.transitionTo('ex-db', {
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