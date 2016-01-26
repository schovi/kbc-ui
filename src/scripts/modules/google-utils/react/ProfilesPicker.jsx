// Google analytics komponenta ktora vynuti od uzivatela docasny oauth token a
// vylistuje mu jeho google analytics profily z ktorych si vyberie
import React, {PropTypes} from 'react';
import {Button} from 'react-bootstrap';

import gapi, {authorize, disconnect, apiKey, injectGapiScript} from './InitGoogleApis';

const scope = 'https://www.googleapis.com/auth/analytics.readonly';

function authorizeAnal(callbackFn) {
  gapi().client.load('analytics', 'v3').then( () => {
    gapi().client.setApiKey(apiKey);
    authorize(scope, callbackFn);
  });
}

function getProfiles() {
  const request = gapi().client.analytics.management.accountSummaries.list();
  request.execute(
    (resp) => {
      console.log('PROFILES', resp);
      disconnect();
    },
    (err) => {
      console.log(err);
    }
  );
}

export default React.createClass({

  propTypes: {
    email: PropTypes.string,
    onProfilesLoad: PropTypes.func
  },

  componentDidMount() {
    injectGapiScript();
  },

  render() {
    return (
      <Button
        bsStyle="success"
        onClick={this.onButtonClick}>
        Pick me up bitch!
      </Button>
    );
  },

  loadAnalProfiles() {
    getProfiles();
  },

  onButtonClick() {
    authorizeAnal((authResult) => {
      if (authResult && !authResult.error) {
        this.loadAnalProfiles();
      }
    });
  }

});
