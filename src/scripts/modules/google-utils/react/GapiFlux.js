import {Map} from 'immutable';
import StoreUtils from '../../../utils/StoreUtils';
import keyMirror from 'react/lib/keyMirror';
import Dispatcher from '../../../Dispatcher';

const ActionTypes = keyMirror({
  GAPI_START_INIT: null,
  GAPI_FINISH_INIT: null,
  GAPI_START_PICK: null,
  GAPI_FINISH_PICK: null,
  GAPI_ERROR: null
});

let _store = Map({
  isInitializing: false,
  isInitialized: false,
  isPicking: Map() // what true/false
});


export const GapiStore = StoreUtils.createStore({
  isInitializing: () => _store.get('isInitializing'),
  isInitialized: () => _store.get('isInitialized'),
  isPicking: (what) => _store.getIn(['isPicking', what], false)
});


Dispatcher.register( (payload) => {
  const action = payload.action;
  switch (action.type) {
    case ActionTypes.GAPI_START_INIT:
      _store = _store.set('isInitializing', true);
      _store = _store.set('isInitialized', false);
      GapiStore.emitChange();
      break;
    case ActionTypes.GAPI_FINISH_INIT:
      _store = _store.set('isInitializing', false);
      _store = _store.set('isInitialized', true);
      GapiStore.emitChange();
      break;

    case ActionTypes.GAPI_START_PICK:
      _store = _store.setIn(['isPicking', action.what], true);
      GapiStore.emitChange();
      break;

    case ActionTypes.GAPI_FINISH_PICK:
      _store = _store.setIn(['isPicking', action.what], false);
      GapiStore.emitChange();
      break;
    default:
      return;
  }
});

export const GapiActions = {
  startInit: () => {
    Dispatcher.handleViewAction({
      type: ActionTypes.GAPI_START_INIT
    });
  },

  finishInit: () => {
    Dispatcher.handleViewAction({
      type: ActionTypes.GAPI_FINISH_INIT
    });
  },

  startPick: (what) => {
    Dispatcher.handleViewAction({
      type: ActionTypes.GAPI_START_PICK,
      what: what
    });
  },

  finishPick: (what) => {
    Dispatcher.handleViewAction({
      type: ActionTypes.GAPI_FINISH_PICK,
      what: what
    });
  }
};
