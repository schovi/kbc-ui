import React from 'react';
import classnames from 'classnames';
import Select from 'react-select';

import ComponentDescription from '../../components/react/components/ComponentDescription';
import AuthorizeModal from './DropboxAuthorizeModal';
import FileSelectorModal from './DropboxFileSelectorModal';
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
import LatestJobs from '../../components/react/components/SidebarJobs';
import ComponentsMetadata from '../../components/react/components/ComponentMetadata';
import { Map, List } from 'immutable';
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
    let parameters = configData.get('parameters', Map());
    let dropboxFiles = ExDropboxStore.getCsvFiles();
    let keboolaBuckets = StorageBucketsStore.getAll();
    let selectedInputBucket = localState.get('selectedInputBucket', Map());
    let selectedDropboxFiles = localState.get('selectedDropboxFiles', Map());
    let isDefaultBucketSelected = localState.get('isDefaultBucketSelected', true);
    let credentials = OAuthStore.getCredentials(componentId, configId);
    let hasCredentials = OAuthStore.hasCredentials(componentId, configId);
    let isDeletingCredentials = OAuthStore.isDeletingCredetials(componentId, configId);

    return {
      latestJobs: LatestJobsStore.getJobs(componentId, configId),
      configId: configId,
      configData: configData,
      parameters: parameters,
      localState: localState,
      dropboxFiles: dropboxFiles,
      keboolaBuckets: keboolaBuckets,
      selectedInputBucket: selectedInputBucket,
      selectedDropboxFiles: selectedDropboxFiles,
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
    }

  },

  renderCSVPicker() {
    if (this.state.hasCredentials) {
      return (
        <div className="section well">
          <h3 className="section-heading">1. Please specify CSV files you want to upload to Keboola.</h3>

          <Select
            multi
            value={this.getSelectedCsvFiles()}
            placeholder="Select CSV files from Dropbox"
            options={this.state.dropboxFiles.get('fileNames')}
            onChange={this.handleCsvSelectChange}
          />
        </div>
      );
    }
  },

  renderFileSelectorModal() {
    return (
      <div className="row component-empty-state text-right">
        <div>
          <ModalTrigger modal={
              <FileSelectorModal
                dropboxFiles={this.state.dropboxFiles.get('fileNames')}
                keboolaBuckets={this.getInputBuckets()}
                configId={this.state.configId}
                selectedCsvFiles={this.getSelectedCsvFiles}
                selectedInputBucket={this.getSelectedBucket}
                handleCsvSelectChange={this.handleCsvSelectChange}
                handleBucketChange={this.handleInputBucketChange}
                canSaveConfig={this.canSaveConfig}
                saveConfig={this.saveConfig}
              />
            }>
            <span className="btn btn-success">Configure Input Files</span>
          </ModalTrigger>
        </div>
      </div>
    );
  },

  getInputBuckets() {
    return this.getBucketsForSelection(this.listBucketNames(this.filterBuckets(this.state.keboolaBuckets)));
  },

  getSelectedCsvFiles() {
    var selectedDropboxFiles = [];
    var inputConfigTables = this.getInputTables();

    // Check whether the local state for selected dropbox files contain any data. We might populate it with actual config.
    if (!this.state.localState.get('selectedDropboxFiles')) {
      // Check the config and store it to localState
      inputConfigTables.map((table) => {
        selectedDropboxFiles.push({label: table.get('source'), value: table.get('source')});
      });

      return selectedDropboxFiles;
    }
    else {
      return this.state.localState.get('selectedDropboxFiles');
    }
  },

  canRunUpload() {
    return (this.getInputTables().count() > 0) && this.state.hasCredentials;
  },

  canSaveConfig() {
    var parameters = this.state.configData.get('parameters');
    var selectedDropboxFiles = this.state.localState.get('selectedDropboxFiles');
    var selectedLocalBucket = this.state.localState.get('selectedInputBucket');
    var selectedConfigBucket = parameters ? parameters.get('bucket') : null;

    // We can save new config whether user changed files selection.
    // On the other hand the bucket may be changed, but we also have to make sure the bucket is set.
    if (typeof selectedDropboxFiles !== 'undefined' && ( selectedLocalBucket || selectedConfigBucket )) {
      return true;
    }
    else {
      return false;
    }
  },

  saveConfig() {
    // MAKE SURE TO DEFINE CLEANING OF THE LOCAL STATES FOR TABLES AND BUCKETS

    console.log('SAVING CONFIGURATION!');
  },

  cancelConfig() {


  },

  getSelectedBucket() {
    var selectedInputBucket = [];
    var inputConfigBucket = this.state.configData.get('parameters');

    // Checking whether the local state is not defined
    if (!this.state.localState.get('selectedInputBucket')) {
      // Check whether the config is set, if not, just return an empty array.

      if (!inputConfigBucket) {
        return selectedInputBucket;
      }

      if (!inputConfigBucket.get('bucket')) {
        return selectedInputBucket;
      }

      selectedInputBucket.push({label: inputConfigBucket.get('bucket'), value: inputConfigBucket.get('bucket')});
      return selectedInputBucket;
    }
    else {
      return this.state.localState.get('selectedInputBucket');
    }
  },


  handleInputBucketChange(value) {
    //let selectedObject = this.state.localState.set('selectedInputBucket', value);
    this.updateLocalState(['selectedInputBucket'], value);
  },


  handleCsvSelectChange(value, values) {
    //let selectedObjects = this.state.localState.set('selectedDropboxFiles', values);
    this.updateLocalState(['selectedDropboxFiles'], values);
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
        {this.renderFileSelectorModal()}
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
            {this.renderResetAuthorization()}
          </li>
          <li>
            <DeleteConfigurationButton
              componentId={componentId}
              configId={this.state.configId}
              customDeleteFn={this.deleteCredentials}
            />
          </li>
          <li>
            <LatestJobs jobs={this.state.latestJobs} />
          </li>
        </ul>
      </div>
    );
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
    if (this.state.hasCredentials && this.getInputTables().size > 0) {

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
            {
              this.getInputTables().map((table, index) => {
                return (
                  <tr>
                      <td>{index + 1}.</td>
                      <td>{table.get('source')}</td>
                      <td>{table.get('destination')}</td>
                      <td className="text-right">
                      <button className="btn btn-link" onClick={this.handleDeletingSingleElement}>
                        <i className="fa kbc-icon-cup"></i>
                      </button>
                      <button className="btn btn-link">
                        <span className="fa fa-upload fa-fw"></span>
                      </button>
                    </td>
                  </tr>
                );
              })
            }
            </tbody>
          </table>
        </div>
      );
    }
  },

  handleDeletingSingleElement() {
    console.log('test');
  },

  getInputTables() {
    return this.state.configData.getIn(['storage', 'input', 'tables']) || List();
  },

  updateAndSaveConfigData(path, data) {
    let newData = this.state.configData.setIn(path, data);
    return InstalledComponentsActions.saveComponentConfigData(componentId, this.state.configId, newData);
  },

  updateParameters(newParameters) {
    this.updateAndSaveConfigData(['parameters'], newParameters);
  },

  getDestinationName(fileName) {
    let destinationFile = fileName.toString().replace(/\//g, '_').toLowerCase().slice(1, -4);
    let defaultBucket = this.defaultInputBucket;

    return `${defaultBucket}.${destinationFile}`;
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


  deleteCredentials() {
    OAuthActions.deleteCredentials(componentId, this.state.configId);
  },

  updateLocalState(path, data) {
    let newLocalState = this.state.localState.setIn(path, data);
    InstalledComponentsActions.updateLocalState(componentId, this.state.configId, newLocalState);
  }

});