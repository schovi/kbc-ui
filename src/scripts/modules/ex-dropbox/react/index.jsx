import React from 'react';
import classnames from 'classnames';
import Select from 'react-select';

import ComponentDescription from '../../components/react/components/ComponentDescription';
import AuthorizeModal from './DropboxAuthorizeModal';
import RunButtonModal from '../../components/react/components/RunComponentButton';
import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';


import { ModalTrigger } from 'react-bootstrap';

import InstalledComponentsStore from '../../components/stores/InstalledComponentsStore';
import ExDropboxStore from '../stores/ExDropboxStore';
import OAuthStore from '../../components/stores/OAuthStore';
import InstalledComponentsActions from '../../components/InstalledComponentsActionCreators';
import ExDropboxActions from '../actions/ExDropboxActionCreators';
import OAuthActions from '../../components/OAuthActionCreators';
import createStoreMixin from '../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../stores/RoutesStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';
import ComponentsMetadata from '../../components/react/components/ComponentMetadata';
import { fromJS, Map, List } from 'immutable';
import { ActivateDeactivateButton, Confirm } from '../../../react/common/common';

const componentId = 'ex-dropbox';


export default React.createClass({

  displayName: 'exDropboxIndex',

  mixins: [createStoreMixin(InstalledComponentsStore, OAuthStore, LatestJobsStore, ExDropboxStore)],

  getStateFromStores() {
    let configId = RoutesStore.getCurrentRouteParam('config');
    let configData = InstalledComponentsStore.getConfigData(componentId, configId);
    let localState = InstalledComponentsStore.getLocalState(componentId, configId);
    let savingData = InstalledComponentsStore.getSavingConfigData(componentId, configId);
    let dropboxFiles = ExDropboxStore.getCsvFiles();
    let selectedDropboxFiles = localState.get('selectedDropboxFiles', Map());
    let toggles = localState.get('bucketToggles', Map());
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
      dropboxFiles: dropboxFiles,
      selectedDropboxFiles: selectedDropboxFiles,
      credentials: credentials,
      hasCredentials: hasCredentials,
      isDeletingCredentials: isDeletingCredentials
    };
  },

  componentDidMount() {
    if (this.state.hasCredentials) {
      let data = this.state.credentials.get('data');
      let token = JSON.parse(data).access_token;

      ExDropboxActions.getListOfCsvFiles(token);
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
        {this.renderCSVPicker()}
        {this.renderBucketSelector()}
        {this.renderConfigSummary()}
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

  renderCSVPicker() {
    if (this.state.hasCredentials) {
      return (
        <div className="section well">
          <h3 className="section-heading">1. Please specify CSV files you want to upload to Keboola.</h3>

          <Select
            multi
            value={this.state.selectedDropboxFiles.get('selectedDropboxFiles')}
            placeholder="Select CSV files from Dropbox"
            options={this.state.dropboxFiles.get('fileNames')}
            onChange={this.handleCsvSelectChange}
          />
        </div>
      );
    }
  },

  renderBucketSelector() {
    if (this.state.hasCredentials) {
      var tmp = ['in.c-main.ExDropbox'];

      return (
        <div className="section well">
          <h3 className="section-heading">2. Please select a Keboola Storage Bucket where the files will be uploaded.</h3>

          <Select
            ref="stateSelect"
            options={this.state.dropboxFiles.get('fileNames')}
            placeholder="Select a Bucket from the Keboola Storage"
            disabled={this.state.disabled}
            value={tmp}
            onChange={this.updateValue}
            searchable={true} />
        </div>
      );
    }
  },

  renderConfigSummary() {
    if (this.state.hasCredentials) {
      return (
        <div className="section">
          <table className="table table-striped">
          <thead>
            <tr>
              <th>Source</th>
              <th>Destination</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>/file2.csv</td>
              <td>in.c-main.ExDropbox.file2</td>
              <td className="text-right">
                <button className="btn btn-link">
                    <i className="fa kbc-icon-cup"></i>
                </button>
                <button className="btn btn-link">
                    <span className="fa fa-upload fa-fw"></span>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        </div>
      );
    }
  },

  handleCsvSelectChange(value, values) {
    let selectedObjects = this.state.selectedDropboxFiles.set('selectedDropboxFiles', values);
    this.updateLocalState(['selectedDropboxFiles'], selectedObjects);
  },

  renderTablesByBucketsPanel() {
    if (this.state.hasCredentials) {
      return (
        <p></p>
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
    InstalledComponentsActions.updateLocalState(componentId, this.state.configId, newLocalState);
  }

});