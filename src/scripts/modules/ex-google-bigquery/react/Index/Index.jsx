import React from 'react';
// import {Map} from 'immutable';

// stores
import storeProvisioning, {storeMixins} from '../../storeProvisioning';
import ComponentStore from '../../../components/stores/ComponentsStore';
import RoutesStore from '../../../../stores/RoutesStore';
import LatestJobsStore from '../../../jobs/stores/LatestJobsStore';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';

// actions
import {deleteCredentialsAndConfigAuth} from '../../../oauth-v2/OauthUtils';
import actionsProvisioning from '../../actionsProvisioning';

// ui components
import QueryTable from './QueryTable';
import ProjectsManagerModal from './ProjectsManagerModal';
import AuthorizationRow from '../../../oauth-v2/react/AuthorizationRow';
import ComponentDescription from '../../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../../components/react/components/ComponentMetadata';
import RunComponentButton from '../../../components/react/components/RunComponentButton';
import DeleteConfigurationButton from '../../../components/react/components/DeleteConfigurationButton';
import EmptyState from '../../../components/react/components/ComponentEmptyState';
import SearchRow from '../../../../react/common/SearchRow';
import Confirm from '../../../../react/common/Confirm';
import Tooltip from '../../../../react/common/Tooltip';
import {Link} from 'react-router';
import LatestJobs from '../../../components/react/components/SidebarJobs';
import LatestVersions from '../../../components/react/components/SidebarVersionsWrapper';
import {Loader} from 'kbc-react-components';

// index components


// CONSTS
const ROUTE_PREFIX = 'ex-db-generic-';
const COMPONENT_ID = 'keboola.ex-google-bigquery';

export default React.createClass({
  mixins: [createStoreMixin(...storeMixins, LatestJobsStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    const store = storeProvisioning(configId);
    const actions = actionsProvisioning(configId);
    const component = ComponentStore.getComponent(COMPONENT_ID);

    return {
      latestJobs: LatestJobsStore.getJobs(COMPONENT_ID, configId),
      store: store,
      actions: actions,
      component: component,
      configId: configId,
      authorizedEmail: store.oauthCredentials.get('authorizedFor'),
      oauthCredentials: store.oauthCredentials,
      oauthCredentialsId: store.oauthCredentialsId,
      queriesFilter: store.filter,
      queriesFiltered: store.queriesFiltered,
      localState: store.getLocalState()
    };
  },

  render() {
    return (
      <div className="container-fluid">
        <ProjectsManagerModal
          authorizedEmail={this.state.store.authorizedEmail}
          isPendingFn={this.state.store.isPending}
          saveFn={this.handleProjectSave}
          show={this.state.localState.getIn(['ProjectsManagerModal', 'projects'], false)}
          onHideFn={this.hideProjectsModal}
          projects={this.state.store.projects}
          google={this.state.store.getEditingGoogle()}
          onChangeFn={this.state.actions.onUpdateEditingGoogle}
          {...this.state.actions.prepareLocalState('ProjectsManagerModal')}
        />

        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <div className="col-sm-8">
              <ComponentDescription
                componentId={COMPONENT_ID}
                configId={this.state.configId}
              />
            </div>
            <div className="col-sm-4 kbc-buttons">
              {this.hasQueries() ? this.renderAddQueryLink() : null}
            </div>
          </div>
          <div className="row">
            {this.renderAuthorizedInfo('col-xs-5')}
            {this.renderProjects('col-xs-7')}
          </div>
          {this.renderSarchForm()}
          {this.renderQueryTable()}
          {this.renderEmptyQueries()}
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <ComponentMetadata
            componentId={COMPONENT_ID}
            configId={this.state.configId}
          />
          <ul className="nav nav-stacked">
            <li className={!!this.invalidToRun() ? 'disabled' : null}>
              <RunComponentButton
                title="Run"
                component={COMPONENT_ID}
                mode="link"
                runParams={this.runParams()}
                disabled={!!this.invalidToRun()}
                disabledReason={this.invalidToRun()}
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
          <LatestJobs jobs={this.state.latestJobs} limit={3} />
          <LatestVersions
            limit={3}
            componentId={COMPONENT_ID}
          />
        </div>
      </div>

    );
  },

  isAuthorized() {
    return this.state.store.isAuthorized();
  },

  hasQueries() {
    return this.state.store.queries && this.state.store.queries.count();
  },

  hasProject() {
    return this.state.store.google && this.state.store.google.get('projectId', null);
  },

  hasStorage() {
    return this.state.store.google && this.state.store.google.get('storage', null);
  },

  invalidToRun() {
    if (!this.isAuthorized()) {
      return 'No Google BigQuery account authorized';
    }

    if (!this.hasProject()) {
      return 'No Google BigQuery Project or Cloud Storage bucketstorage specified';
    }

    if (!this.hasStorage()) {
      return 'No Google Cloud Storage bucket specified';
    }

    if (!this.hasQueries()) {
      return 'No queries configured yet';
    }

    return false;
  },

  handleFilterChange(query) {
    this.state.actions.setQueriesFilter(query);
  },

  handleProjectSave(google) {
    this.state.actions.saveGoogle(google).then(() => this.state.actions.updateLocalState(['ProjectsManagerModal', 'projects'], false));
  },

  handleProjectReset() {
    this.state.actions.resetGoogle();
  },

  hideProjectsModal() {
    this.state.actions.cancelEditingGoogle();
    this.state.actions.updateLocalState(['ProjectsManagerModal', 'projects'], false);
  },

  showProjectsModal() {
    this.state.actions.startEditingGoogle();
    this.state.actions.loadAccountProjects(); // @move to component will mount?
    return this.state.actions.updateLocalState(['ProjectsManagerModal', 'projects'], true);
  },

  renderProjectInfo() {
    return (
      <span>
        <button type="button" className="btn btn-link btn-sm"
          onClick={this.showProjectsModal}>
          Edit
          {' '}
          <span className="kbc-icon-pencil" />
        </button>
        <div className="static-modal">
          Billable BigQuery Project: <strong>{this.state.store.google.get('projectId', null)}</strong>
        </div>
        <div className="static-modal">
          CloudStorage bucket: <strong>{this.state.store.google.get('storage', null)}</strong>
        </div>
        <div className="static-modal">
          <Confirm
            text="Do you really want to reset the Google configuration?"
            title="Reset Authorization"
            buttonLabel="Reset Google configuration"
            onConfirm={this.handleProjectReset}>
            <span className="btn btn-link btn-sm" style={{'padding-top': 0, 'padding-bottom': 0, 'paddingLeft': 0}}>

              { this.state.store.isPending(['projectId'])
                ?
                <Loader />
                :
                <Tooltip tooltip="Reset Google configuration" placement="top">
                  <span>Reset</span>
                </Tooltip>
              }
            </span>
          </Confirm>
        </div>
      </span>
    );
  },

  renderProjects(clName) {
    if (this.isAuthorized()/* || this.hasProfiles()*/) {
      return (
        <div className={clName}>
          <div className="form-group form-group-sm">
            <label> Google configuration </label>
            {this.hasProject() ?
             this.renderProjectInfo()
             :
             <EmptyState>
               <p> No configuration found </p>
               <button type="button" className="btn btn-success btn-sm"
                 onClick={this.showProjectsModal}>
                 Configure
               </button>
             </EmptyState>
            }
          </div>
        </div>

      );
    }
    return null;
  },

  renderAuthorizedInfo(clName) {
    return (
      <AuthorizationRow
        className={this.isAuthorized() ? clName : 'col-xs-12'}
        id={this.state.oauthCredentialsId}
        configId={this.state.configId}
        componentId={COMPONENT_ID}
        credentials={this.state.oauthCredentials}
        isResetingCredentials={false}
        onResetCredentials={this.deleteCredentials}
        showHeader={false}
      />
    );
  },

  renderSarchForm() {
    if (this.hasQueries() > 0) {
      return (
        <SearchRow
          className="row kbc-search-row"
          onChange={this.handleFilterChange}
          query={this.state.queriesFilter} />
      );
    }
    return null;
  },

  renderQueryTable() {
    if (this.hasQueries() > 0) {
      if (this.state.queriesFiltered.count()) {
        return (
          <QueryTable
            queries={this.state.queriesFiltered}
            configId={this.state.configId}
            componentId={COMPONENT_ID}
            queryDetailRoute={ROUTE_PREFIX + COMPONENT_ID + '-query'}
            isPendingFn={this.state.store.isPending}
            deleteQueryFn={this.handleDelete}
            toggleQueryEnabledFn={this.handleToggle}
            getRunSingleQueryDataFn={this.state.store.getRunSingleQueryData}
          />
        );
      } else {
        return (
          <div className="table table-striped">
            <div className="tfoot">
              <div className="tr">
                <div className="td">No queries found</div>
              </div>
            </div>
          </div>
        );
      }
    }
    return null;
  },

  renderAddQueryLink() {
    if (this.hasProject() && this.hasStorage()) {
      return (
        <Link
          to={ROUTE_PREFIX + COMPONENT_ID + '-new-query'}
          params={{config: this.state.configId}}
          className="btn btn-success">
          <span className="kbc-icon-plus" /> Add Query
        </Link>
      );
    }
    return null;
  },

  renderEmptyQueries() {
    if (!this.hasQueries() && this.isAuthorized() && this.hasProject()) {
      return (
        <div className="row">
          <EmptyState>
            <p>No queries configured yet.</p>
            {this.renderAddQueryLink()}
          </EmptyState>
        </div>
      );
    }
    return null;
  },

  runParams() {
    return () => ({config: this.state.configId});
  },

  handleDelete(qid) {
    this.state.actions.deleteQuery(qid);
  },

  handleToggle(qid) {
    this.state.actions.changeQueryEnabledState(qid);
  },

  deleteCredentials() {
    deleteCredentialsAndConfigAuth(COMPONENT_ID, this.state.configId);
  }

});
