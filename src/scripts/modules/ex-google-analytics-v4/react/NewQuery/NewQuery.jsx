import React from 'react';

// stores
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import storeProvisioning, {storeMixins} from '../../storeProvisioning';
import RoutesStore from '../../../../stores/RoutesStore';
import {GapiStore} from '../../../google-utils/react/GapiFlux';

// actions
import actionsProvisioning from '../../actionsProvisioning';
import {injectGapiScript} from '../../../google-utils/react/InitGoogleApis';

// ui components
import QueryEditor from '../components/QueryEditor/QueryEditor';

// CONSTS
// const COMPONENT_ID = 'keboola.ex-google-analytics-v4';


export default React.createClass({

  mixins: [createStoreMixin(...storeMixins, GapiStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    const store = storeProvisioning(configId);
    const actions = actionsProvisioning(configId);
    const newQuery = store.getNewQuery();
    const isGaInitialized = GapiStore.isInitialized();
    const isLoadingMetadata = GapiStore.isLoadingMetadata();
    const metadata = GapiStore.getMetadata();

    return {
      isLoadingMetadata: isLoadingMetadata,
      metadata: metadata,
      isGaInitialized: isGaInitialized,
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
    injectGapiScript();
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
      this.state.isGaInitialized ?
      <QueryEditor divClassName={contentClassName}
        isEditing={true}
        isLoadingMetadata={this.state.isLoadingMetadata}
        metadata={this.state.metadata}
        isGaInitialized={this.state.isGaInitialized}
        allProfiles={this.state.store.profiles}
        outputBucket={this.state.store.outputBucket}
        onChangeQuery={this.state.actions.onUpdateNewQuery}

        query={this.state.newQuery}
        {...this.state.actions.prepareLocalState('NewQuery')}/>
    : null );
  }
});
