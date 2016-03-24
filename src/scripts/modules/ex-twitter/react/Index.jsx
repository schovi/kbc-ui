import React from 'react';

// stores
import InstalledComponentStore from '../../components/stores/InstalledComponentsStore';
import ComponentStore from '../../components/stores/ComponentsStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';
import RoutesStore from '../../../stores/RoutesStore';
import OauthStore from '../../oauth-v2/Store';
import createStoreMixin from '../../../react/mixins/createStoreMixin';


import Wizard from './Wizard';
import {Steps} from '../constants';

import {
  changeWizardStep
} from '../actions';

const COMPONENT_ID = 'keboola.ex-twitter';

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, LatestJobsStore, ComponentStore, OauthStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      localState = InstalledComponentStore.getLocalState(COMPONENT_ID, configId),
      configData =  InstalledComponentStore.getConfigData(COMPONENT_ID, configId),
      oauthCredentialsId = configData.getIn(['authorization', 'oauth_api', 'id'], configId),
      oauthCredentials = OauthStore.getCredentials(COMPONENT_ID, oauthCredentialsId);

    return {
      component: ComponentStore.getComponent(COMPONENT_ID),
      config: InstalledComponentStore.getConfig(COMPONENT_ID, configId),
      configData: configData,
      latestJobs: LatestJobsStore.getJobs(COMPONENT_ID, configId),
      isSaving: InstalledComponentStore.isSavingConfigData(COMPONENT_ID, configId),
      localState: localState,
      isAuthorized: configData.hasIn(['authorization', 'oauth_api', 'id']),
      oauthCredentials: oauthCredentials,
      oauthCredentialsId: oauthCredentialsId,
      wizardStep: localState.get('wizardStep', Steps.STEP_AUTHORIZATION)
    };
  },

  render() {
    console.log('state', this.state.config.toJS(), this.state.configData.toJS(), this.state.oauthCredentials);
    return this.renderWizard();
  },

  renderWizard() {
    return (
      <div className="container-fluid">
        <div className="col-md-12 kbc-main-content">
          <Wizard
            step={this.state.wizardStep}
            oauthCredentials={this.state.oauthCredentials}
            oauthCredentialsId={this.state.oauthCredentialsId}
            onStepChange={this.changeWizardStep}
            />
        </div>
      </div>
    );
  },

  renderConfigured() {
    return (
      <div className="container-fluid">
        <div className="col-md-12 kbc-main-content">
          Configured
        </div>
      </div>
    );
  },

  changeWizardStep(newStep) {
    changeWizardStep(this.state.config.get('id'), newStep);
  }

});