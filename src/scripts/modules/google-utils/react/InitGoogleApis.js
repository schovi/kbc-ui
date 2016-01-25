import _ from 'underscore';
const apiUrl = 'https://apis.google.com/js/client.js?onload=handleGoogleClientLoad';
const clientId = '682649748090-hdan66m2vvudud332s99aud36fs15idj.apps.googleusercontent.com';

// import request from '../../../utils/request';

let gapi;
let initialized = false;

if (!window.handleGoogleClientLoad) {
  window.handleGoogleClientLoad = function() {
    gapi = window.gapi;
    gapi.load('picker');
    // gapi.load('auth');
    gapi.load('auth2', () => initialized = true);
  };
}

export function authorize(scope, callbackFn) {
  const authObject = gapi.auth2.getAuthInstance() || gapi.auth2.init({
    'client_id': clientId,
    'scope': scope,
    'fetch_basic_profile': false
  });

  const sigInOptions = {
    'fetch_basic_profile': false,
    'scope': scope,
    'prompt': 'select_account'

  };
  if (authObject.isSignedIn.get()) {
    callbackFn();
  } else {
    return authObject.signIn(sigInOptions).then((params) => {
      callbackFn(params);
    }, (err) => console.log('SIGN FAILED', err));
  }
}

export function disconnect() {
  const authObject = gapi.auth2.getAuthInstance();
  if (authObject) {
    console.log('DISCONNECT');
    authObject.signOut().then(() => {
      console.log('SIGN OUT');
      authObject.disconnect();
    });
  }
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
