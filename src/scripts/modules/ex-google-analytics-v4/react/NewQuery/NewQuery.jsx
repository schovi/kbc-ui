import React from 'react';

// stores
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import storeProvisioning, {storeMixins} from '../../storeProvisioning';
import RoutesStore from '../../../../stores/RoutesStore';
import {GapiStore} from '../../../google-utils/react/GapiFlux';

// actions
import actionsProvisioning from '../../actionsProvisioning';
// import {injectGapiScript} from '../../../google-utils/react/InitGoogleApis';
import {GapiActions} from '../../../google-utils/react/GapiFlux';

// ui components
import QueryEditor from '../components/QueryEditor/QueryEditor';

export default React.createClass({

  mixins: [createStoreMixin(...storeMixins, GapiStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    const store = storeProvisioning(configId);
    const actions = actionsProvisioning(configId);
    const newQuery = store.getNewQuery();
    const isLoadingMetadata = GapiStore.isLoadingMetadata();
    const metadata = GapiStore.getMetadata();

    return {
      isLoadingMetadata: isLoadingMetadata,
      metadata: metadata,
      newQuery: newQuery,
      store: store,
      actions: actions,
      configId: configId,
      localState: store.getLocalState()
    };
  },

  componentWillReceiveProps() {
    this.setState(this.getStateFromStores());
  },

  componentDidMount() {
    GapiActions.loadAnalyticsMetadata();
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        {this.renderQueryEditor()}
      </div>

    );
  },

  renderQueryEditor() {
    const contentClassName = 'row';
    return (
      <QueryEditor divClassName={contentClassName}
        isEditing={true}
        isLoadingMetadata={this.state.isLoadingMetadata}
        metadata={this.state.metadata}
        allProfiles={this.state.store.profiles}
        outputBucket={this.state.store.outputBucket}
        onChangeQuery={this.state.actions.onUpdateNewQuery}
        onRunQuery={this.state.actions.runQuerySample}
        query={this.state.newQuery}
        {...this.state.actions.prepareLocalState('NewQuery')}/>
    );
  }
});
