import actions from '../components/InstalledComponentsActionCreators';
import store from '../components/stores/InstalledComponentsStore';
import {List, fromJS} from 'immutable';

const COMPONENT_ID = 'keboola.ex-twitter';



export function changeWizardStep(configId, newStep) {
  const localState = store.getLocalState(COMPONENT_ID, configId);

  actions.updateLocalState(COMPONENT_ID, configId,
    localState.set('wizardStep', newStep)
  );
}