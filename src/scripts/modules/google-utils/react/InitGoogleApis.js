import _ from 'underscore';
const apiUrl = 'https://apis.google.com/js/client.js?onload=handleGoogleClientLoad';
const clientId = '682649748090-hdan66m2vvudud332s99aud36fs15idj.apps.googleusercontent.com';
export const apiKey = 'AIzaSyBYjYUY81-DWMZBuNYRWOTSLt9NZqWG0cc';

// import request from '../../../utils/request';

let gapi;
let initialized = false;

if (!window.handleGoogleClientLoad) {
  window.handleGoogleClientLoad = function() {
    gapi = window.gapi;
    gapi.load('picker');
    gapi.load('auth');
    initialized = true;
  };
}

export function authorize(scope, callBackFn) {
  const signInOptions = {
    'client_id': clientId,
    'scope': scope,
    'cookie_policy': 'single_host_origin',
    'prompt': 'select_account'
  };
  return gapi.auth.authorize(signInOptions, callBackFn);
}

export function disconnect() {
  gapi.auth.signOut();
  gapi.auth.setToken(null);
}

/*
function authorize(scope, email, callbackFn) {
  return gapi.auth.authorize(
    {
      'client_id': clientId,
      'scope': scope,
      'immediate': false,
      'user_id': email
    }
    , callbackFn);
}

export function authorizeGoogleAccount(scope, email, callbackFn, preloadPromise) {
  if (preloadPromise) {
    return preloadPromise.then(() => authorize(scope, email, callbackFn));
  } else {
    return authorize(scope, email, callbackFn);
  }
}

*/


export function injectGapiScript() {
  const scripts = document.body.getElementsByTagName('script');
  const apiScript = _.find(scripts, (s) =>
                           s.src === apiUrl
                          );
  if (!apiScript && _.isUndefined(window.gapi)) {
    let script = document.createElement('script');
    script.src = apiUrl;
    document.body.appendChild(script);
  }
}

export default function() {
  return window.gapi;
}

export function isInitialized() {
  return initialized;
}
