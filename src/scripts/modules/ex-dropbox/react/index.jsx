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
import StorageActionCreators from '../../components/StorageActionCreators';
import StorageBucketsStore from '../../components/stores/StorageBucketsStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';
import ComponentsMetadata from '../../components/react/components/ComponentMetadata';
import { fromJS, Map, List } from 'immutable';
import { ActivateDeactivateButton, Confirm } from '../../../react/common/common';

const componentId = 'ex-dropbox';


export default React.createClass({

  displayName: 'exDropboxIndex',

  defaultInputBucket: 'in.c-main.ExDropbox',

  mixins: [createStoreMixin(InstalledComponentsStore, OAuthStore, LatestJobsStore, ExDropboxStore, StorageBucketsStore)],

  getStateFromStores() {
    let configId = RoutesStore.getCurrentRouteParam('config');
    let configData = InstalledComponentsStore.getConfigData(componentId, configId);
    let localState = InstalledComponentsStore.getLocalState(componentId, configId);
    let savingData = InstalledComponentsStore.getSavingConfigData(componentId, configId);
    let dropboxFiles = ExDropboxStore.getCsvFiles();
    let keboolaBuckets = StorageBucketsStore.getAll();
    let selectedDropboxFiles = localState.get('selectedDropboxFiles', Map());
    let selectedInputBucket = localState.get('selectedInputBucket', Map());
    let toggles = localState.get('bucketToggles', Map());
    let isDefaultBucketSelected = localState.get('isDefaultBucketSelected', true);
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
      keboolaBuckets: keboolaBuckets,
      selectedDropboxFiles: selectedDropboxFiles,
      selectedInputBucket: selectedInputBucket,
      credentials: credentials,
      isDefaultBucketSelected: isDefaultBucketSelected,
      hasCredentials: hasCredentials,
      isDeletingCredentials: isDeletingCredentials
    };
  },

  componentDidMount() {
    if (this.state.hasCredentials) {
      this.handleSelectionOfDefaultBucket(true);

      let data = this.state.credentials.get('data');
      let token = JSON.parse(data).access_token;

      ExDropboxActions.getListOfCsvFiles(token);
      StorageActionCreators.loadBucketsForce();

      console.log('InputTables: ', this.getInputTables());
      console.log('configId: ', this.state.configId);
    }

  },

  getInputTables() {
    return this.state.configData.getIn(['storage', 'input', 'tables']) || List();
  },

  updateAndSaveConfigData(path, data) {
    let newData = this.state.configData.setIn(path, data);
    let saveFunction = InstalledComponentsActions.saveComponentConfigData;
    saveFunction(componentId, this.state.configId, newData);
  },

  updateParameters(newParameters) {
    this.updateAndSaveConfigData(['parameters'], newParameters);
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
      var inputBuckets = this.getBucketsForSelection(this.listBucketNames(this.filterBuckets(this.state.keboolaBuckets)));

      return (
        <div className="section well">
          <h3 className="section-heading">2. Please specify a Keboola Storage Bucket where the files will be uploaded.</h3>

          <label className="checkbox" style={{'marginLeft': '20px'}}>
            <input type="checkbox" className="checkbox-control" checked={this.state.localState.get('isDefaultBucketSelected')} onChange={this.handleToggleOfSelectionOfDefaultBucket} />
            <span className="checkbox-label">Use bucket: {this.defaultInputBucket} (default option)</span>
          </label>

          <p className="hint">The component for Bucket Selection below is disabled. Uncheck the option for usage of <strong>{this.defaultInputBucket}</strong> if you want to enable it.</p>

          <Select
            ref="stateSelect"
            options={inputBuckets}
            placeholder="Select a different Bucket from the Keboola Storage"
            disabled={this.state.localState.get('isDefaultBucketSelected')}
            value={this.state.selectedInputBucket.get('selectedInputBucket')}
            onChange={this.handleInputBucketChange}
            searchable={true} />
        </div>
      );
    }
  },

  hasSelectedDropboxFiles() {
    var selectedFiles = this.state.selectedDropboxFiles.get('selectedDropboxFiles');

    if (typeof (selectedFiles) !== 'undefined') {
      if (selectedFiles.length > 0) {
        return true;
      }
      else {
        return false;
      }
    }
  },

  renderConfigSummary() {
    if (this.state.hasCredentials && this.hasSelectedDropboxFiles()) {
      return (
        <div className="section">
          <table className="table table-striped">
          <thead>
            <tr>
              <th>#</th>
              <th>Source</th>
              <th>Destination</th>
              <th></th>
            </tr>
          </thead>
            <tbody>
              <tr>
                <td>1. </td>
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

  handleInputBucketChange(value) {
    let selectedObject = this.state.selectedInputBucket.set('selectedInputBucket', value);
    this.updateLocalState(['selectedInputBucket'], selectedObject);
  },

  handleToggleOfSelectionOfDefaultBucket() {
    let isChecked = this.state.localState.get('isDefaultBucketSelected');

    if (isChecked) {
      this.handleSelectionOfDefaultBucket(!isChecked);
    }
    else {
      this.handleSelectionOfDefaultBucket(!isChecked);
    }
  },

  handleSelectionOfDefaultBucket(newValue) {
    this.updateLocalState(['isDefaultBucketSelected'], newValue);
  },

  filterBuckets(buckets) {
    let inputBuckets = buckets.filter((bucket) => {
      return bucket.get('stage') === 'in';
    });

    return inputBuckets;
  },

  listBucketNames(buckets) {
    var bucketNameList = [];

    buckets.map((bucketObject, bucketId) => {
      bucketNameList.push(bucketId);
    });

    return bucketNameList;
  },

  getBucketsForSelection(buckets) {
    return buckets.map((bucketName) => {
      return { value: bucketName, label: bucketName };
    });
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

  updateLocalState(path, data) {
    let newLocalState = this.state.localState.setIn(path, data);
    InstalledComponentsActions.updateLocalState(componentId, this.state.configId, newLocalState);
  }

});