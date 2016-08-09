import React from 'react';

// stores
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import storeProvisioning, {storeMixins} from '../../storeProvisioning';
import RoutesStore from '../../../../stores/RoutesStore';
import {GapiStore} from '../../../google-utils/react/GapiFlux';

// actions
import actionsProvisioning from '../../actionsProvisioning';
import {GapiActions} from '../../../google-utils/react/GapiFlux';
// import {injectGapiScript} from '../../../google-utils/react/InitGoogleApis';

// ui components
import QueryEditor from '../components/QueryEditor/QueryEditor';
import QueryNav from './QueryNav';


export default React.createClass({

  mixins: [createStoreMixin(...storeMixins, GapiStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    const queryId = RoutesStore.getCurrentRouteParam('queryId');
    const store = storeProvisioning(configId);
    const actions = actionsProvisioning(configId);
    const query = store.getConfigQuery(queryId);
    const editingQuery = store.getEditingQuery(queryId);
    const isLoadingMetadata = GapiStore.isLoadingMetadata();
    const metadata = GapiStore.getMetadata();

    return {
      isLoadingMetadata: isLoadingMetadata,
      metadata: metadata,
      query: query,
      queryId: queryId,
      editingQuery: editingQuery,
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
    const isEditing = !!this.state.editingQuery;
    let contentClassName = 'col-md-9 kbc-main-content-with-nav';
    if (isEditing) {
      contentClassName = 'row';
    }
    return (
      <div className="container-fluid kbc-main-content">
        {isEditing ? null :
         <div className="col-md-3 kbc-main-nav">
           <div className="kbc-container">
             <QueryNav
               configurationId={this.state.configId}
               queries={this.state.store.queriesFiltered}
               filter={this.state.store.filter}
               setQueriesFilter={this.state.actions.setQueriesFilter}
             />

           </div>
         </div>
        }
         {this.renderQueryEditor(contentClassName, isEditing)}
      </div>

    );
  },

  renderQueryEditor(contentClassName, isEditing) {
    return (
      <QueryEditor divClassName={contentClassName}
        isEditing={isEditing}
        isLoadingMetadata={this.state.isLoadingMetadata}
        metadata={this.state.metadata}
        allProfiles={this.state.store.profiles}
        outputBucket={this.state.store.outputBucket}
        onChangeQuery={this.state.actions.onChangeEditingQueryFn(this.state.queryId)}
        onRunQuery={this.state.actions.runQuerySample}
        query={isEditing ? this.state.editingQuery : this.state.query}
        {...this.state.actions.prepareLocalState('QueryDetail' + this.state.queryId)}/>
    );
  }

});
