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
      configuration: dbStore.getConfig(config),
      isEditing: dbStore.isEditingCredentials(config),
      editingCredentials: dbStore.getEditingCredentials(config),
      isSaving: dbStore.isSavingCredentials(config)
    };
  },

  render() {
    return (
      <Credentials
        credentials={ this.getCredentials() }
        isEditing={ this.state.isEditing && !this.state.isSaving }
        onChange={ this.handleChange }
        />
    );
  },

  handleChange(newCredentials) {
    actionCreators.updateEditingCredentials(this.state.configuration.get('id'), newCredentials);
  },

  getCredentials() {
    return this.state.isEditing ? this.state.editingCredentials : this.state.configuration.get('credentials');
  }

});