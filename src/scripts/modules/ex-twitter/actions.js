import actions from '../components/InstalledComponentsActionCreators';
import store from '../components/stores/InstalledComponentsStore';
import {createConfigurationFromSettings, getSettingsFromConfiguration} from './template';
import {Map} from 'immutable';

const COMPONENT_ID = 'keboola.ex-twitter';

export function saveSettings(configId) {
  const localState = store.getLocalState(COMPONENT_ID, configId),
    config = store.getConfigData(COMPONENT_ID, configId)
      .setIn(['parameters'], createConfigurationFromSettings(localState.get('settings', Map())));

  return actions.saveComponentConfigData(COMPONENT_ID, configId, config).then(() => {
    actions.updateLocalState(COMPONENT_ID, configId,
      localState.remove('settings')
    );
  })
}

export function changeSettings(configId, newSettings) {
  const localState = store.getLocalState(COMPONENT_ID, configId);

  actions.updateLocalState(COMPONENT_ID, configId,
    localState.set('settings', newSettings)
  );
}

export function editSettingsStart(configId) {
  const settings = getSettingsFromConfiguration(store.getConfigData(COMPONENT_ID, configId).get('parameters', Map())),
    localState = store.getLocalState(COMPONENT_ID, configId);
  actions.updateLocalState(COMPONENT_ID, configId,
    localState.set('settings', settings)
  );
}

export function editSettingsCancel(configId) {
  const localState = store.getLocalState(COMPONENT_ID, configId);
  actions.updateLocalState(COMPONENT_ID, configId,
    localState.remove('settings')
  );
}

export function changeWizardStep(configId, newStep) {
  const localState = store.getLocalState(COMPONENT_ID, configId);

  actions.updateLocalState(COMPONENT_ID, configId,
    localState.set('wizardStep', newStep)
  );
}