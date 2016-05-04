// Google analytics komponenta ktora vynuti od uzivatela docasny oauth token a
// vylistuje mu jeho google analytics profily z ktorych si vyberie
import React, {PropTypes} from 'react';
import Tooltip from '../../../react/common/Tooltip';
import {Button} from 'react-bootstrap';
import _ from 'underscore';

import {GapiStore} from './GapiFlux';
import createStoreMixin from '../../../react/mixins/createStoreMixin';

import gapi, {authorize, disconnect, apiKey, injectGapiScript} from './InitGoogleApis';

const scope = 'https://www.googleapis.com/auth/analytics.readonly';

function authorizeAnal(callbackFn) {
  gapi().client.load('analytics', 'v3').then( () => {
    gapi().client.setApiKey(apiKey);
    authorize(scope, callbackFn);
  });
}

function reparseProfiles(profiles) {
  let result = {};
  _.each(profiles.items, (item) => {
    const accountId = item.id;
    let props = {};
    _.each(item.webProperties, (property) => {
      const webPropertyId = property.id;
      _.each(property.profiles, (p) => {
        p.accountId = accountId;
        p.webPropertyId = webPropertyId;
      });
      props[property.name] = property.profiles;
    });
    result[item.name] = props;
  });
  return result;
}

export default React.createClass({

  mixins: [createStoreMixin(GapiStore)],

  propTypes: {
    email: PropTypes.string,
    buttonLabel: PropTypes.string,
    onProfilesLoad: PropTypes.func,
    onProfilesLoadError: PropTypes.func
  },

  getDefaultProps() {
    return {
      buttonLabel: 'Select Google Account and Load Profiles'
    };
  },

  getStateFromStores() {
    return {
      isInitialized: GapiStore.isInitialized(),
      isPicking: GapiStore.isPicking('profiles')
    };
  },

  componentDidMount() {
    injectGapiScript();
  },

  render() {
    return (
      <Button
        disabled={!this.state.isInitialized}
        bsStyle="success"
        onClick={this.onButtonClick}>
        {this.props.buttonLabel}
          <Tooltip
             tooltip="Requires temporal authorization of a Google Account after which a short-lived access token is obtained to load profiles from the selected account."
             placement="top">
            <i className="fa fa-fw fa-question-circle"></i>
          </Tooltip>

      </Button>
    );
  },

  loadAnalProfiles() {
    const request = gapi().client.analytics.management.accountSummaries.list();
    request.execute(
      (resp) => {
        console.log('PROFILES', resp);
        disconnect();
        if (resp.error) {
          return this.props.onProfilesLoadError(resp);
        } else {
          this.props.onProfilesLoad(reparseProfiles(resp), resp.username);
        }
      }
    );
  },

  onButtonClick() {
    authorizeAnal((authResult) => {
      if (authResult && !authResult.error) {
        this.loadAnalProfiles();
      }
    });
  }

});
