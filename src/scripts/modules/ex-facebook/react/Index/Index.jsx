import React from 'react';
// import {Map} from 'immutable';

// stores
import storeProvisioning, {storeMixins} from '../../storeProvisioning';
import ComponentStore from '../../../components/stores/ComponentsStore';
import RoutesStore from '../../../../stores/RoutesStore';
import LatestJobsStore from '../../../jobs/stores/LatestJobsStore';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';

// actions
import {deleteCredentialsAndConfigAuth} from '../../../oauth-v2/OauthUtils';
import actionsProvisioning from '../../actionsProvisioning';

// ui components
import AuthorizationRow from '../../../oauth-v2/react/AuthorizationRow';
import ComponentDescription from '../../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../../components/react/components/ComponentMetadata';
import RunComponentButton from '../../../components/react/components/RunComponentButton';
import DeleteConfigurationButton from '../../../components/react/components/DeleteConfigurationButton';
import EmptyState from '../../../components/react/components/ComponentEmptyState';
// import {Link} from 'react-router';
import LatestJobs from '../../../components/react/components/SidebarJobs';
import LatestVersions from '../../../components/react/components/SidebarVersionsWrapper';


// CONSTS
const COMPONENT_ID = 'keboola.ex-facebook';

export default React.createClass({
  mixins: [createStoreMixin(...storeMixins, LatestJobsStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    const store = storeProvisioning(configId);
    const actions = actionsProvisioning(configId);
    const component = ComponentStore.getComponent(COMPONENT_ID);

    return {
      latestJobs: LatestJobsStore.getJobs(COMPONENT_ID, configId),
      store: store,
      actions: actions,
      component: component,
      configId: configId,
      authorizedEmail: store.oauthCredentials.get('authorizedFor'),
      oauthCredentials: store.oauthCredentials,
      oauthCredentialsId: store.oauthCredentialsId,
      localState: store.getLocalState()
    };
  },

  render() {
    return (
      <div className="container-fluid">

        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <div className="col-sm-10">
              <ComponentDescription
                componentId={COMPONENT_ID}
                configId={this.state.configId}
              />
            </div>
            <div className="col-sm-2 kbc-buttons">
              {this.isAuthorized() ? this.renderAddQueryLink() : null}
            </div>
          </div>
          <div className="row">
            {this.renderAuthorizedInfo('col-xs-10')}
          </div>
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <ComponentMetadata
            componentId={COMPONENT_ID}
            configId={this.state.configId}
          />
          <ul className="nav nav-stacked">
            <li className={!!this.invalidToRun() ? 'disabled' : null}>
              <RunComponentButton
                title="Run Extraction"
                component={COMPONENT_ID}
                mode="link"
                runParams={this.runParams()}
                disabled={!!this.invalidToRun()}
                disabledReason={this.invalidToRun()}
              >
                You are about to run extraction.
              </RunComponentButton>
            </li>
            {/* <li>
                <a href={this.state.component.get('documentationUrl')} target="_blank">
                <i className="fa fa-question-circle fa-fw" /> Documentation
                </a>
                </li> */}
        <li>
          <DeleteConfigurationButton
            componentId={COMPONENT_ID}
            configId={this.state.configId}
          />
        </li>
          </ul>
          <LatestJobs jobs={this.state.latestJobs} limit={3} />
          <LatestVersions
            limit={3}
            componentId={COMPONENT_ID}
          />
        </div>
      </div>
    );
  },

  isAuthorized() {
    return this.state.store.isAuthorized();
  },


  invalidToRun() {
    if (!this.isAuthorized()) {
      return 'No Facebook account authorized';
    }
    return false;
  },

  renderAuthorizedInfo(clName) {
    return (
      <AuthorizationRow
        className={this.isAuthorized() ? clName : 'col-xs-12'}
        id={this.state.oauthCredentialsId}
        configId={this.state.configId}
        componentId={COMPONENT_ID}
        credentials={this.state.oauthCredentials}
        isResetingCredentials={false}
        onResetCredentials={this.deleteCredentials}
        showHeader={false}
      />
    );
  },

  renderAddQueryLink() {
    return (
      <button
        className="btn btn-success"
        onClick={() => {}}>
        Add Query
      </button>
    );
  },

  renderEmptyQueries() {
    return (
      this.isAuthorized() ?
      <div className="row">
        <EmptyState>
          <p>No Queries Configured</p>
          {this.renderAddQueryLink()}
        </EmptyState>
      </div>
      : null
    );
  },

  runParams() {
    return () => ({config: this.state.configId});
  },


  deleteCredentials() {
    deleteCredentialsAndConfigAuth(COMPONENT_ID, this.state.configId);
  }
});
