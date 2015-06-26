import React from 'react';
import ExDbStore from '../../exDbStore';
import RoutesStore from '../../../../stores/RoutesStore';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import QueryDeleteButton from './QueryDeleteButton';
import RunExtractionButton from '../../../components/react/components/RunComponentButton';
import ActivateDeactivateButton from '../../../../react/common/ActivateDeactivateButton';
import actionCreators from '../../exDbActionCreators';
import {Map} from 'immutable';

export default React.createClass({
  mixins: [createStoreMixin(ExDbStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      queryId = RoutesStore.getCurrentRouteIntParam('query'),
      query = ExDbStore.getConfigQuery(configId, queryId);

    return {
      configId: configId,
      queryId: queryId,
      query: query,
      pendingActions: ExDbStore.getQueriesPendingActions(configId).get(query.get('id'), Map())
    };
  },

  render() {
    return (
      <div>
        <QueryDeleteButton
          query={this.state.query}
          configurationId={this.state.configId}
          isPending={this.state.pendingActions.has('deleteQuery')}
          tooltipPlacement="bottom"
          />
        <ActivateDeactivateButton
          activateTooltip="Enable Query"
          deactivateTooltip="Disable Query"
          isActive={this.state.query.get('enabled')}
          isPending={this.state.pendingActions.has('enabled')}
          onChange={this.handleActiveChange}
          tooltipPlacement="bottom"
          />
        <RunExtractionButton
          title="Run Extraction"
          component="ex-db"
          runParams={this.runParams}
          config={this.state.configId}
          tooltipPlacement="bottom"
        >
          You are about to run extraction
        </RunExtractionButton>
      </div>
    );
  },

  runParams() {
    return {
      config: this.state.configId,
      query: this.state.query.get('id')
    };
  },

  handleActiveChange(newValue) {
    actionCreators.changeQueryEnabledState(this.state.configId, this.state.query.get('id'), newValue);
  }

});