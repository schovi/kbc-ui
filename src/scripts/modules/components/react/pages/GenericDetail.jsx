import React from 'react';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../../stores/RoutesStore';
import InstalledComponentStore from '../../stores/InstalledComponentsStore';
import LatestJobsStore from '../../../jobs/stores/LatestJobsStore';

import ComponentDescription from '../components/ComponentDescription';
import ComponentMetadata from '../components/ComponentMetadata';
import RunComponentButton from '../components/RunComponentButton';
import DeleteConfigurationButton from '../components/DeleteConfigurationButton';
import LatestJobs from '../components/SidebarJobs';

import {Button} from 'react-bootstrap';

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, LatestJobsStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      componentId = RoutesStore.getCurrentRouteParam('component');

    return {
      componentId: componentId,
      configData: InstalledComponentStore.getConfigData(componentId, configId),
      config: InstalledComponentStore.getConfig(componentId, configId),
      latestJobs: LatestJobsStore.getJobs(componentId, configId)
    };
  },

  render() {
    return (
      <div className="container-fluid">
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <ComponentDescription
              componentId={this.state.componentId}
              configId={this.state.config.get('id')}
              />
          </div>
          <div className="row">
            <div classNmae="col-xs-4">
              <p>This component has to be configured manually, please contact our support for assistance.</p>
              <div className="kbc-buttons">
                <Button onClick={this.contactSupport} bsStyle="success">
                  Contact Support
                </Button>
              </div>
            </div>
          </div>
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <div classNmae="kbc-buttons kbc-text-light">
            <ComponentMetadata
              componentId={this.state.componentId}
              configId={this.state.config.get('id')}
              />
          </div>
          <ul className="nav nav-stacked">
            <li>
              <RunComponentButton
                title="Run"
                component={this.state.componentId}
                mode="link"
                runParams={this.runParams()}
                >
                You are about to run component.
              </RunComponentButton>
            </li>
            <li>
              <DeleteConfigurationButton
                componentId={this.state.componentId}
                configId={this.state.config.get('id')}
                />
            </li>
          </ul>
          <LatestJobs jobs={this.state.latestJobs} />
        </div>
      </div>
    );
  },

  runParams() {
    return () => ({config: this.state.config.get('id')});
  },

  contactSupport() {
    /*global Zenbox*/
    /* eslint camelcase: 0 */
    Zenbox.init({
      request_subject: 'Configuration assistance request'
    });
    Zenbox.show();
  }

});