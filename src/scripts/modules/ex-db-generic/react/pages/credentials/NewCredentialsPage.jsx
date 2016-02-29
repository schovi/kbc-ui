import React from 'react';
import Credentials from './Credentials';
import createStoreMixin from '../../../../../react/mixins/createStoreMixin';
import dbStore from '../../../exDbStore';
import routesStore from '../../../../../stores/RoutesStore';
import actionCreators from '../../../exDbActionCreators';

export default React.createClass({
  mixins: [createStoreMixin(dbStore)],

  getStateFromStores() {
    const config = routesStore.getCurrentRouteParam('config');
    return {
      configurationId: config,
      credentials: dbStore.getNewCredentials(config),
      isSaving: dbStore.isSavingCredentials(config)
    };
  },

  render() {
    return (
      <Credentials
        credentials={ this.state.credentials }
        isEditing={ !this.state.isSaving }
        onChange={ this.handleChange }
        />
    );
  },

  handleChange(newCredentials) {
    actionCreators.updateNewCredentials(this.state.configurationId, newCredentials);
  }

});