import actions from '../components/InstalledComponentsActionCreators';
import store from '../components/stores/InstalledComponentsStore';
import {List, fromJS} from 'immutable';
import {createConfigurationFromSettings} from './template';

const COMPONENT_ID = 'keboola.ex-twitter';

function updateLocalState(configId, newState) {
  actions.updateLocalState(COMPONENT_ID, configId, newState);
}


export function saveSettings(configId) {
  const settings = store.getLocalState(COMPONENT_ID, configId).get('settings'),
    config = store.getConfigData(COMPONENT_ID, configId)
      .setIn(['parameters'], createConfigurationFromSettings(settings));

  return actions.saveComponentConfigData(COMPONENT_ID, configId, config)
}

export function changeSettings(configId, newSettings) {
  const localState = store.getLocalState(COMPONENT_ID, configId);

  actions.updateLocalState(COMPONENT_ID, configId,
    localState.set('settings', newSettings)
  );
}


export function changeWizardStep(configId, newStep) {
  const localState = store.getLocalState(COMPONENT_ID, configId);

  actions.updateLocalState(COMPONENT_ID, configId,
    localState.set('wizardStep', newStep)
  );
}