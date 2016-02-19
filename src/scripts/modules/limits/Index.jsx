import React from 'react';
import ApplicationStore from '../../stores/ApplicationStore';
import createStoreMixin from '../../react/mixins/createStoreMixin';
import LimitRow from './LimitRow';
import StorageApi from '../components/StorageApi';
import Keen from 'keen-js';

export default React.createClass({
  mixins: [createStoreMixin(ApplicationStore)],

  getInitialState() {
    return {
      client: null,
      isKeenReady: false
    };
  },

  componentDidMount() {
    StorageApi
      .getKeenCredentials()
      .then((response) => {
        const client = new Keen({
          readKey: response.keenToken,
          projectId: '5571e4d559949a32ff02043e'
        });
        this.setState({
          client: client
        });
        Keen.ready(this.keenReady);
      });
  },

  getStateFromStores() {
    return {
      sections: ApplicationStore.getLimits()
    };
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        <ul className="nav nav-tabs">
          <li role="presentation">
            <a href={this.projectPageUrl('settings')}>Settings</a>
          </li>
          <li role="presentation" className="active">
            <a href={this.projectPageUrl('settings-limits')}>Limits</a>
          </li>
          <li role="presentation">
            <a href={this.projectPageUrl('settings-users')}>Users</a>
          </li>
        </ul>
        {this.state.sections.map(this.section)}
      </div>
    );
  },

  projectPageUrl(path) {
    return ApplicationStore.getProjectPageUrl(path);
  },

  section(section) {
    return (
      <div>
        <div className="kbc-header">
          <div className="kbc-title">
            <h2>
               <span className="kb-sapi-component-icon">
                <img src={section.get('icon')} />
              </span>
              {section.get('title')}
            </h2>
          </div>
        </div>
        <div className="table">
          <div className="tbody">
            {section.get('limits').map(this.tableRow)}
          </div>
        </div>
      </div>
    );
  },

  tableRow(limit) {
    return React.createElement(LimitRow, {
      limit: limit,
      isKeenReady: this.state.isKeenReady,
      keenClient: this.state.client,
      key: limit.get('id')
    });
  },

  keenReady() {
    this.setState({
      isKeenReady: true
    });
  }

});