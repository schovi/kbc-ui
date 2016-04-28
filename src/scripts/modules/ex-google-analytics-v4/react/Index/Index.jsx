import React from 'react';
// stores
import InstalledComponentStore from '../../../components/stores/InstalledComponentsStore';
import ComponentStore from '../../../components/stores/ComponentsStore';
import RoutesStore from '../../../../stores/RoutesStore';
import OauthStore from '../../../oauth-v2/Store';
// import LatestJobsStore from '../../../jobs/stores/LatestJobsStore';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';

// actions
import {deleteCredentialsAndConfigAuth} from '../../../oauth-v2/OauthUtils';

// ui components
import AuthorizationRow from '../../../oauth-v2/react/AuthorizationRow';
import ComponentDescription from '../../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../../components/react/components/ComponentMetadata';
import RunComponentButton from '../../../components/react/components/RunComponentButton';
import DeleteConfigurationButton from '../../../components/react/components/DeleteConfigurationButton';

const COMPONENT_ID = 'keboola.ex-google-analytics-v4';

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, OauthStore)],
  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    const localState = InstalledComponentStore.getLocalState(COMPONENT_ID, configId);
    const configData =  InstalledComponentStore.getConfigData(COMPONENT_ID, configId);
    const component = ComponentStore.getComponent(COMPONENT_ID);
    const oauthCredentialsId = configData.getIn(['authorization', 'oauth_api', 'id'], configId);

    return {
      component: component,
      configId: configId,
      configData: configData,
      localState: localState,
      oauthCredentials: OauthStore.getCredentials(COMPONENT_ID, oauthCredentialsId),
      oauthCredentialsId: oauthCredentialsId
    };
  },

  render() {
    return (
      <div className="container-fluid">
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <ComponentDescription
              componentId={COMPONENT_ID}
              configId={this.state.configId}
              />
          </div>
          <div className="row">
            <AuthorizationRow
              id={this.state.oauthCredentialsId}
              configId={this.state.configId}
              componentId={COMPONENT_ID}
              credentials={this.state.oauthCredentials}
              isResetingCredentials={false}
              onResetCredentials={this.deleteCredentials}
              showHeader={false}
              />
          </div>
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <ComponentMetadata
            componentId={COMPONENT_ID}
            configId={this.state.configId}
          />
          <ul className="nav nav-stacked">
            <li>
              <RunComponentButton
                title="Run"
                component={COMPONENT_ID}
                mode="link"
                runParams={this.runParams()}
                disabledReason="Component is not configured yet"
                >
                You are about to run component.
              </RunComponentButton>
            </li>
            <li>
              <a href={this.state.component.get('documentationUrl')} target="_blank">
                <i className="fa fa-question-circle fa-fw" /> Documentation
              </a>
            </li>
            <li>
              <DeleteConfigurationButton
                componentId={COMPONENT_ID}
                configId={this.state.configId}
                />
            </li>
          </ul>
          {/* <LatestJobs jobs={this.state.latestJobs} /> */}
        </div>
      </div>

    );
  },

  runParams() {
    return () => ({config: this.state.configId});
  },


  deleteCredentials() {
    deleteCredentialsAndConfigAuth(COMPONENT_ID, this.state.configId);
  }

});
