// Google analytics komponenta ktora vynuti od uzivatela docasny oauth token a
// vylistuje mu jeho google analytics profily z ktorych si vyberie
import React, {PropTypes} from 'react';
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

/*

For some reason the second webProperty has no profiles and that makes the UI go wild

 */
const faultyProfiles = {
  'kind': 'analytics#accountSummaries',
  'username': 'onndra@keboola.com',
  'totalResults': 1,
  'startIndex': 1,
  'itemsPerPage': 1000,
  'items': [
    {
      'id': '1',
      'kind': 'analytics#accountSummary',
      'name': 'My Account',
      'webProperties': [
        {
          'kind': 'analytics#webPropertySummary',
          'id': 'UA-1-1',
          'name': 'http://www.keboola.com',
          'internalWebPropertyId': '1',
          'level': 'STANDARD',
          'websiteUrl': 'http://www.keboola.cz',
          'profiles': [
            {
              'kind': 'analytics#profileSummary',
              'id': '1',
              'name': 'Hlavní',
              'type': 'WEB'
            },
            {
              'kind': 'analytics#profileSummary',
              'id': '2',
              'name': 'Vedlejší',
              'type': 'WEB'
            }
          ]
        },
        {
          'kind': 'analytics#webPropertySummary',
          'id': 'UA-1-2',
          'name': 'http://www.keboola.com',
          'internalWebPropertyId': '2',
          'level': 'STANDARD',
          'websiteUrl': 'http://www.keboola.com'
        }
      ]
    }
  ]
};

function reparseProfiles(profiles) {
  let result = {};
  _.each(profiles.items, (item) => {
    const accountId = item.id;
    const accountName = item.name;
    let props = {};
    _.each(item.webProperties, (property) => {
      const webPropertyId = property.id;
      const webPropertyName = property.name;
      props[property.name] = _.map(property.profiles, (p) => {
        let profile = {};
        profile.accountId = accountId;
        profile.webPropertyId = webPropertyId;
        profile.webPropertyName = webPropertyName;
        profile.accountName = accountName;
        profile.name = p.name;
        profile.id = p.id;
        return profile;
      });
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
      buttonLabel: 'Load Profiles'
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
      </Button>
    );
  },

  loadAnalProfiles() {
    const request = gapi().client.analytics.management.accountSummaries.list();
    request.execute(
      (resp) => {
        disconnect();
        if (resp.error) {
          return this.props.onProfilesLoadError(resp);
        } else {
          // FIXME remove
          // return this.props.onProfilesLoad(reparseProfiles(resp), resp.username);
          return this.props.onProfilesLoad(reparseProfiles(faultyProfiles), resp.username);
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
