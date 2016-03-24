import React from 'react';
import {Map} from 'immutable';

// stores
import InstalledComponentStore from '../../components/stores/InstalledComponentsStore';
import ComponentStore from '../../components/stores/ComponentsStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';
import RoutesStore from '../../../stores/RoutesStore';
import OauthStore from '../../oauth-v2/Store';
import createStoreMixin from '../../../react/mixins/createStoreMixin';
import {getSettingsFromConfiguration} from '../template';


import Wizard from './Wizard';
import {Steps} from '../constants';

import AuthorizationRow from '../../oauth-v2/react/AuthorizationRow';
import ComponentDescription from '../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../components/react/components/ComponentMetadata';
import RunComponentButton from '../../components/react/components/RunComponentButton';
import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';
import LatestJobs from '../../components/react/components/SidebarJobs';

import {
  changeWizardStep,
  changeSettings,
  saveSettings
} from '../actions';

const COMPONENT_ID = 'keboola.ex-twitter';

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, LatestJobsStore, ComponentStore, OauthStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      localState = InstalledComponentStore.getLocalState(COMPONENT_ID, configId),
      configData =  InstalledComponentStore.getConfigData(COMPONENT_ID, configId),
      oauthCredentialsId = configData.getIn(['authorization', 'oauth_api', 'id'], configId),
      oauthCredentials = OauthStore.getCredentials(COMPONENT_ID, oauthCredentialsId),
      settings = getSettingsFromConfiguration(configData.get('parameters', Map())),
      settingsEditing = localState.get('settings', settings),
      isConfigured = configData.has('parameters');

    return {
      component: ComponentStore.getComponent(COMPONENT_ID),
      config: InstalledComponentStore.getConfig(COMPONENT_ID, configId),
      configData: configData,
      latestJobs: LatestJobsStore.getJobs(COMPONENT_ID, configId),
      isSaving: InstalledComponentStore.isSavingConfigData(COMPONENT_ID, configId),
      isAuthorized: configData.hasIn(['authorization', 'oauth_api', 'id']),
      oauthCredentials: oauthCredentials,
      oauthCredentialsId: oauthCredentialsId,
      wizardStep: localState.get('wizardStep', isConfigured ? Steps.STEP_USER_TIMELINE : Steps.STEP_AUTHORIZATION),
      settingsEditing: settingsEditing,
      settings: settings,
      isConfigured: isConfigured
    };
  },

  render() {
    console.log('state', this.state.config.toJS(), this.state.configData.toJS(), this.state.oauthCredentials);
    return this.state.isConfigured ? this.renderConfigured() : this.renderWizard();
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
            componentId={this.state.component.get('id')}
            configId={this.state.config.get('id')}
            settings={this.state.settingsEditing}
            onChange={this.onSettingsChange}
            isSaving={this.state.isSaving}
            onSave={this.onSave}
            />
        </div>
      </div>
    );
  },

  renderConfigured() {
    return (
      <div className="container-fluid">
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <ComponentDescription
              componentId={this.state.component.get('id')}
              configId={this.state.config.get('id')}
              />
          </div>
          <div className="row">
            <AuthorizationRow
              id={this.state.oauthCredentialsId}
              componentId={this.state.component.get('id')}
              credentials={this.state.oauthCredentials}
              isResetingCredentials={false}
              onResetCredentials={this.deleteCredentials}

              />
          </div>
          <Wizard
            step={this.state.wizardStep}
            oauthCredentials={this.state.oauthCredentials}
            oauthCredentialsId={this.state.oauthCredentialsId}
            onStepChange={this.changeWizardStep}
            componentId={this.state.component.get('id')}
            configId={this.state.config.get('id')}
            settings={this.state.settingsEditing}
            onChange={this.onSettingsChange}
            isSaving={this.state.isSaving}
            onSave={this.onSave}
            isStatic={true}
            />
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <ul className="nav nav-stacked">
            <li>
              <ComponentMetadata
                componentId={this.state.component.get('id')}
                configId={this.state.config.get('id')}
                />
            </li>
            <li>
              <RunComponentButton
                title="Run"
                component={this.state.component.get('id')}
                mode="link"
                runParams={this.runParams()}
                disabledReason="Component is not configured yet"
                >
                You are about to run component.
              </RunComponentButton>
            </li>
            <li>
              <DeleteConfigurationButton
                componentId={this.state.component.get('id')}
                configId={this.state.config.get('id')}
                />
            </li>
          </ul>
          <LatestJobs jobs={this.state.latestJobs} />
        </div>
      </div>
    );
  },

  onSave() {
    saveSettings(this.state.config.get('id'));
  },

  changeWizardStep(newStep) {
    changeWizardStep(this.state.config.get('id'), newStep);
  },

  onSettingsChange(newSetttings) {
    changeSettings(this.state.config.get('id'), newSetttings);
  },
  runParams() {
    return () => ({config: this.state.config.get('id')});
  }

});