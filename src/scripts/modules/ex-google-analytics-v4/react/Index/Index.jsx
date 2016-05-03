import React from 'react';
// stores
import storeProvisioning, {storeMixins} from '../../storeProvisioning';
import ComponentStore from '../../../components/stores/ComponentsStore';
import RoutesStore from '../../../../stores/RoutesStore';

// import LatestJobsStore from '../../../jobs/stores/LatestJobsStore';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';

// actions
import {deleteCredentialsAndConfigAuth} from '../../../oauth-v2/OauthUtils';
import actionsProvisioning from '../../actionsProvisioning';

// ui components
import AuthorizationRow from '../../../oauth-v2/react/AuthorizationRow';
import ComponentDescription from '../../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../../components/react/components/ComponentMetadata';
import RunComponentButton from '../../../components/react/components/RunComponentButton';
import DeleteConfigurationButton from '../../../components/react/components/DeleteConfigurationButton';
import EmptyState from '../../../components/react/components/ComponentEmptyState';
/* import {FormControls} from 'react-bootstrap';
 *const StaticText = FormControls.Static;*/

// index components
import QueriesTable from './QueriesTable';

// CONSTS
const COMPONENT_ID = 'keboola.ex-google-analytics-v4';

console.log(storeMixins);

export default React.createClass({
  mixins: [createStoreMixin(...storeMixins)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    const store = storeProvisioning(configId);
    const actions = actionsProvisioning(configId);
    const component = ComponentStore.getComponent(COMPONENT_ID);
    console.log('RENDER');
    return {
      store: store,
      actions: actions,
      component: component,
      configId: configId,
      oauthCredentials: store.oauthCredentials,
      oauthCredentialsId: store.oauthCredentialsId
    };
  },

  render() {
    const queries = this.state.store.queries;
    return (
      <div className="container-fluid">
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <ComponentDescription
              componentId={COMPONENT_ID}
              configId={this.state.configId}
            />
          </div>
          <div className="row">
            <AuthorizationRow
              className="col-xs-6"
              id={this.state.oauthCredentialsId}
              configId={this.state.configId}
              componentId={COMPONENT_ID}
              credentials={this.state.oauthCredentials}
              isResetingCredentials={false}
              onResetCredentials={this.deleteCredentials}
              showHeader={false}
            />
            {this.renderProfiles('col-xs-6')}
          </div>
          <div className="row">
            {(queries && queries.count() > 0)
             ? this.renderQueriesTable()
             : this.renderEmptyQueries()
            }
          </div>
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <ComponentMetadata
            componentId={COMPONENT_ID}
            configId={this.state.configId}
          />
          <ul className="nav nav-stacked">
            <li>
              <RunComponentButton
                title="Run"
                component={COMPONENT_ID}
                mode="link"
                runParams={this.runParams()}
                disabledReason="Component is not configured yet"
              >
                You are about to run component.
              </RunComponentButton>
            </li>
            <li>
              <a href={this.state.component.get('documentationUrl')} target="_blank">
                <i className="fa fa-question-circle fa-fw" /> Documentation
              </a>
            </li>
            <li>
              <DeleteConfigurationButton
                componentId={COMPONENT_ID}
                configId={this.state.configId}
              />
            </li>
          </ul>
          {/* <LatestJobs jobs={this.state.latestJobs} /> */}
        </div>
      </div>

    );
  },

  renderProfiles(clName) {
    /* return (
     *  <div className={clName}>
     *    <StaticText
     *      wrapperClassName="wrapper"
     *      label="Profiles"
     *      bsSize="small">
     *      <div>asdasd</div>
     *      <div>asdasd</div>
     *      <div>asdasd</div>
     *    </StaticText>
     *  </div>
     *);*/

    return (
      <div className={clName}>
        <div className="form-group form-group-sm">
          <label> Profiles </label>
          <div>
            <div className="form-control-static">
              <div>Keboola Website/ Keboola Website/ All Web Site Data</div>
              <div>Keboola Website/ Keboola Website/ All Web Site Data</div>
              <div>and 5 more</div>
            </div>
          </div>
        </div>
      </div>
    );
  },

  renderQueriesTable() {
    return (
      <QueriesTable
        queries={this.state.store.queries}
        allProfiles={this.state.store.profiles}
        {...this.state.actions.prepareLocalState('QueriesTable')}
      />
    );
  },

  renderEmptyQueries() {
    return (
      <EmptyState>
        <p>No Queries Configured</p>
        <button
          type="button"
          className="btn btn-success">
          Add Query
        </button>
      </EmptyState>
    );
  },

  runParams() {
    return () => ({config: this.state.configId});
  },


  deleteCredentials() {
    deleteCredentialsAndConfigAuth(COMPONENT_ID, this.state.configId);
  }

});
