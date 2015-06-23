
import {RefreshIcon} from 'kbc-react-components';
import React from 'react';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import GoodDataWriterStore from '../../store';
import RoutesStore from '../../../../stores/RoutesStore';
import {loadConfigurationForce} from '../../actionCreators';

export default React.createClass({
  mixins: [createStoreMixin(GoodDataWriterStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    return {
      isLoading: GoodDataWriterStore.getWriter(configId).get('isLoading'),
      configId: configId
    };
  },

  render() {
    return (
      <RefreshIcon
        isLoading={this.state.isLoading}
        onClick={this.handleClick}
        />
    );
  },

  handleClick() {
    loadConfigurationForce(this.state.configId);
  }

});
