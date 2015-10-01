import React from 'react';
import classnames from 'classnames';

import ComponentDescription from '../../components/react/components/ComponentDescription';
import AuthorizeModal from './DropboxAuthorizeModal';
import RunButtonModal from '../../components/react/components/RunComponentButton';
import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';


import { ModalTrigger } from 'react-bootstrap';

import SearchRow from '../../../react/common/SearchRow';

import InstalledComponentsStore from '../../components/stores/InstalledComponentsStore';
import OAuthStore from '../../components/stores/OAuthStore';
import InstalledComponentsActions from '../../components/InstalledComponentsActionCreators';
import OAuthActions from '../../components/OAuthActionCreators';
import createStoreMixin from '../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../stores/RoutesStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';
import ComponentsMetadata from '../../components/react/components/ComponentMetadata';
import { fromJS, Map, List } from 'immutable';
import { ActivateDeactivateButton, Confirm } from '../../../react/common/common';
import Api from '../utils/api';


const componentId = 'ex-dropbox';


export default React.createClass({

  displayName: 'exDropboxIndex',

  mixins: [createStoreMixin(InstalledComponentsStore, OAuthStore, LatestJobsStore)],

  getStateFromStores() {
    let configId = RoutesStore.getCurrentRouteParam('config');
    let configData = InstalledComponentsStore.getConfigData(componentId, configId);
    let localState = InstalledComponentsStore.getLocalState(componentId, configId);
    let toggles = localState.get('bucketToggles', Map());
    let savingData = InstalledComponentsStore.getSavingConfigData(componentId, configId);
    let credentials = OAuthStore.getCredentials(componentId, configId);
    let hasCredentials = OAuthStore.hasCredentials(componentId, configId);
    let isDeletingCredentials = OAuthStore.isDeletingCredetials(componentId, configId);

    return {
      latestJobs: LatestJobsStore.getJobs(componentId, configId),
      configId: configId,
      configData: configData,
      localState: localState,
      bucketToggles: toggles,
      savingData: savingData || Map(),
      credentials: credentials,
      hasCredentials: hasCredentials,
      isDeletingCredentials: isDeletingCredentials
    };
  },

  componentDidMount() {
    if (this.state.hasCredentials) {
      let data = this.state.credentials.get('data');
      let token = JSON.parse(data).access_token;

      Api.getCsvFilesFromDropbox(token)
        .then((test) => {
          console.log(test);
        });
    }

  },

  render() {
    return (
      <div className="container-fluid">
        {this.renderMainContent()}
        {this.renderSideBar()}
      </div>
    );
  },

  renderMainContent() {
    return (
      <div className="col-md-9 kbc-main-content">
        <div className="row">
          <ComponentDescription
            componentId={componentId}
            configId={this.state.configId}
          />
        </div>
        {this.renderSearchRow()}
        {this.renderTablesByBucketsPanel()}
      </div>
    );
  },

  getAuthorizationInformation() {
    if (this.state.hasCredentials) {
      return (
        <strong>{this.state.credentials.get('description')}</strong>
      );
    }
    else {
      return (
        <strong>not authorized</strong>
      );
    }
  },

  renderSideBar() {
    return (
      <div className='col-md-3 kbc-main-sidebar'>
        <div className='kbc-buttons kbc-text-light'>
          <p><span>Authorized for {this.getAuthorizationInformation()}</span></p>

          <ComponentsMetadata componentId={componentId} configId={this.state.configId} />
        </div>
        <ul className='nav nav-stacked'>
          <li className={classnames({disabled: !this.canRunUpload()})}>
            <RunButtonModal
              title='Upload selected tables'
              icon='fa fa-fw fa-upload'
              mode='link'
              component='ex-dropbox'
              disabled={!this.canRunUpload()}
              disabledReason='A Dropbox account must be authorized and some table selected.'
            />
          </li>
          <li>
            <DeleteConfigurationButton
              componentId={componentId}
              configId={this.state.configId}
              customDeleteFn={this.deleteCredentials}
            />
          </li>
          <li>
            {this.renderResetAuthorization()}
          </li>
        </ul>
      </div>
    );
  },

  renderSearchRow() {
    if (this.state.hasCredentials) {
      return (
        <SearchRow
          className="row kbc-search-row"
          onChange={this.handleSearchQueryChange}
          query={this.state.localState.get('searchQuery')}
        />
      );
    }
  },

  renderTablesByBucketsPanel() {
    if (this.state.hasCredentials) {
      return (
        <p>Authorized!</p>
      );
    }
    else {
      return (
        <div className="row component-empty-state text-center">
          <div>
            <p>No Dropbox account authorized!</p>
            <ModalTrigger modal={<AuthorizeModal configId={this.state.configId} />}>
              <span className="btn btn-success"><i className="fa fa-fw fa-dropbox"></i>Authorize Dropbox Account</span>
            </ModalTrigger>
          </div>
        </div>
      );
    }
  },

  renderResetAuthorization() {
    if (this.state.hasCredentials) {
      let description = this.state.credentials.get('description');
      return (
        <ActivateDeactivateButton
          mode='link'
          activateTooltip=''
          deactivateTooltip='Reset Authorization'
          isActive='true'
          isPending={this.state.isDeletingCredentials}
          onChange={this.deleteCredentials}
        >
        <Confirm
          text={`Do you really want to reset the authorization of ${description}? Tables configured to upload will not be reset.`}
          title={`Reset Authorization ${description}`}
          buttonLabel='Reset'
          onConfirm={this.deleteCredentials}
        />
        </ActivateDeactivateButton>
      );
    }
    else {
      return (
        <ModalTrigger modal={<AuthorizeModal configId={this.state.configId} />}>
          <span className="btn btn-link"><i className="fa fa-fw fa-user"></i>Authorize Dropbox Account</span>
        </ModalTrigger>
      );
    }
  },

  canRunUpload() {
    return (this.getInputTables().count() > 0) && this.state.hasCredentials;
  },

  deleteCredentials() {
    OAuthActions.deleteCredentials(componentId, this.state.configId);
  },

  updateParameters(newParameters) {
    this.updateAndSaveConfigData(['parameters'], newParameters);
  },

  handleExportChange(tableId) {
    let handleExport = (newExportStatus) => {
      if (newExportStatus) {
        this.addTableExport(tableId);
      }
      else {
        this.removeTableExport(tableId);
      }
    };

    return handleExport;
  },

  addTableExport(tableId) {
    let intables = this.getInputTables();
    let jstable = {
      source: tableId,
      destination: `${tableId}.csv`
    };

    let localTable = intables.find((table) => {
      return table.get('source') === tableId;
    });

    if (!localTable) {
      localTable = fromJS(jstable);
      intables = intables.push(localTable);
      this.updateAndSaveConfigData(['storage', 'input', 'tables'], intables);
    }
  },

  removeTableExport(tableId) {
    let intables = this.getInputTables();
    intables = intables.filter((table) => {
      return table.get('source') !== tableId;
    });

    this.updateAndSaveConfigData(['storage', 'input', 'tables'], intables);
  },

  isTableExported(tableId) {
    let intables = this.getInputTables();
    return !!intables.find((table) => {
      return table.get('source') === tableId;
    });
  },

  filterBuckets(buckets) {
    let bucketsList = buckets.filter((bucket) => {
      return bucket.get('stage') === 'out';
    });

    return bucketsList;
  },

  isBucketToggled(bucketId) {
    return !!this.state.bucketToggles.get(bucketId);
  },

  handleToggleBucket(bucketId) {
    let newValue = !this.isBucketToggled(bucketId);
    let newToggles = this.state.bucketToggles.set(bucketId, newValue);
    this.updateLocalState(['bucketToggles'], newToggles);
  },

  handleSearchQueryChange(newQuery) {
    this.updateLocalState(['searchQuery'], newQuery);
  },

  getInputTables() {
    return this.state.configData.getIn(['storage', 'input', 'tables']) || List();
  },

  updateAndSaveConfigData(path, data) {
    let newData = this.state.configData.setIn(path, data);
    let saveFn = InstalledComponentsActions.saveComponentConfigData;
    saveFn(componentId, this.state.configId, newData);
  },

  updateLocalState(path, data) {
    let newLocalState = this.state.localState.setIn(path, data);
    console.log(newLocalState);
    InstalledComponentsActions.updateLocalState(componentId, this.state.configId, newLocalState);
  }

});