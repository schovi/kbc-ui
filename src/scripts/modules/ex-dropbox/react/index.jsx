import React from 'react';
import classnames from 'classnames';
import Select from 'react-select';

import ComponentDescription from '../../components/react/components/ComponentDescription';
import AuthorizeModal from './DropboxAuthorizeModal';
import FileSelectorModal from './DropboxFileSelectorModal';
import RunButtonModal from '../../components/react/components/RunComponentButton';
import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';

import { ModalTrigger } from 'react-bootstrap';

import actions from '../../components/InstalledComponentsActionCreators';


import InstalledComponentsStore from '../../components/stores/InstalledComponentsStore';
import ExDropboxStore from '../stores/ExDropboxStore';
import OAuthStore from '../../components/stores/OAuthStore';
import ExDropboxActions from '../actions/ExDropboxActionCreators';
import OAuthActions from '../../components/OAuthActionCreators';
import createStoreMixin from '../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../stores/RoutesStore';
import StorageActionCreators from '../../components/StorageActionCreators';
import StorageBucketsStore from '../../components/stores/StorageBucketsStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';
import LatestJobs from '../../components/react/components/SidebarJobs';
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
      this.updateLocalState(['dropboxToken'], token);
    }
  },

  canSaveConfig() {
    var hasLocalConfigDataFiles = this.state.localState.has('selectedDropboxFiles');
    var hasLocalConfigDataBucket = this.state.localState.has('selectedInputBucket');
    var hasConfigDataFiles = this.state.configData.hasIn(['parameters', 'config', 'files']);
    var hasConfigDataBucket = this.state.configData.hasIn(['parameters', 'config', 'bucket']);


    // We can save new config whether user changed files selection.
    // On the other hand the bucket may be changed, but we also have to make sure the bucket is set.
    if ((hasLocalConfigDataFiles || hasConfigDataFiles) && (hasLocalConfigDataBucket || hasConfigDataBucket)) {
      return false;
    }
    else {
      return true;
    }
  },

  updateParameters(newParameters) {
    this.updateAndSaveConfigData(['parameters'], newParameters);
  },

  updateAndSaveConfigData(path, data) {
    let newData = this.state.configData.setIn(path, data);
    return actions.saveComponentConfigData(componentId, this.state.configId, newData);
  },


  saveConfig() {
    var bucketData = this.state.localState.has('selectedInputBucket') ? this.state.localState.get('selectedInputBucket') : this.state.configData.getIn(['parameters', 'config', 'bucket']);
    var filesData = this.state.localState.has('selectedDropboxFiles') ? List(fromJS(this.extractValues(this.state.localState.get('selectedDropboxFiles')))) : this.state.configData.getIn(['parameters', 'config', 'files']);

    var newData = Map()
      .setIn(['parameters', 'config', 'bucket'], bucketData)
      .setIn(['parameters', 'config', 'files'], filesData)
      .setIn(['parameters', 'config', 'credentials'], this.state.localState.get('dropboxToken'));

    return actions.saveComponentConfigData(componentId, this.state.configId, newData);
  },

  canRunUpload() {
    return (this.state.configData.hasIn(['parameters', 'config', 'files']) && this.state.configData.getIn(['parameters', 'config', 'files']).count() > 0 && this.state.hasCredentials);
  },

  getSelectedCsvFiles() {
    var selectedDropboxFiles = [];

    var configDataFiles = this.state.configData.getIn(['parameters', 'config', 'files'], List());
    var localConfigDataFiles = this.state.localState.get('selectedDropboxFiles');
    var hasLocalConfigDataFiles = this.state.localState.has('selectedDropboxFiles');

    // Initial situation where no table is stored in configuration.
    if (configDataFiles.count() === 0) {
      // Situation where files are selected, but the main config is still empty.
      // Return the selected files.
      if (hasLocalConfigDataFiles) {
        localConfigDataFiles.map((fileName) => {
          selectedDropboxFiles.push(fileName);
        });
      }
    }
    // Else handle the situation where at least 1 file had been stored in configuration.
    else {
      // File selection wasn't updated.
      // Return the information from the config.
      if (!hasLocalConfigDataFiles) {
        configDataFiles.map((fileName) => {
          selectedDropboxFiles.push({label: fileName, value: fileName});
        });
      }
      // File selection was updated.
      // Return the information from the selection.
      else {
        localConfigDataFiles.map((fileName) => {
          selectedDropboxFiles.push(fileName);
        });
      }
    }

    return selectedDropboxFiles;
  },

  getSelectedBucket() {
    var selectedInputBucket = [];

    var configDataBucket = this.state.configData.getIn(['parameters', 'config', 'bucket']);
    var hasConfigDataBucket = this.state.configData.hasIn(['parameters', 'config', 'bucket']);
    var localConfigDataBucket = this.state.localState.get('selectedInputBucket');
    var hasLocalConfigDataBucket = this.state.localState.has('selectedInputBucket');

    // Initial situation where no bucket is stored in configuration.
    if (!hasConfigDataBucket) {
      // If some change in selection.
      // Return the local change.
      if (hasLocalConfigDataBucket) {
        console.log('LocalConfigDataBucket: ', localConfigDataBucket);
        selectedInputBucket.push({label: localConfigDataBucket, value: localConfigDataBucket});
      }
    }
    // Else handle a situation where some information about bucket is stored in configuration.
    else {
      // If no selection is made.
      // Return the configData information.
      if (!hasLocalConfigDataBucket) {
        console.log('configDataBucket: ', configDataBucket);
        selectedInputBucket.push({label: configDataBucket, value: configDataBucket});
      }
      // The last condition handle the situation where a update of bucket selection is made.
      // Return the local change.
      else {
        console.log('LocalConfigDataBucket: ', localConfigDataBucket);
        selectedInputBucket.push({label: localConfigDataBucket, value: localConfigDataBucket});
      }
    }

    return selectedInputBucket;
  },


  handleCsvSelectChange(value, values) {
    this.updateLocalState(['selectedDropboxFiles'], values);
  },

  handleInputBucketChange(value) {
    this.updateLocalState(['selectedInputBucket'], value);
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
                cancelConfig={this.cancelConfig}
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



  extractValues(inputArray) {
    var returnArray = [];

    inputArray.map((value) => {
      returnArray.push(value.label);
    });

    return returnArray;
  },

  cancelConfig() {
    console.log('CANCELING CONFIGURATION!');
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
    if (this.state.hasCredentials && this.state.configData.getIn(['parameters', 'config', 'files'], List()).count() > 0) {
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
              this.state.configData.getIn(['parameters', 'config', 'files'], List()).map((table, index) => {
                var handleDeletingSingleElement = this.handleDeletingSingleElement.bind(this, index);
                var handleUploadingSingleElement = this.handleUploadingSingleElement.bind(this, index);
                var destinationFile = this.state.configData.getIn(['parameters', 'config', 'bucket']);
                return (
                  <tr>
                      <td>{index + 1}.</td>
                      <td>{table}</td>
                      <td>{destinationFile}</td>
                      <td className="text-right">
                      <button className="btn btn-link" onClick={handleDeletingSingleElement}>
                        <i className="fa kbc-icon-cup"></i>
                      </button>
                      <button className="btn btn-link" onClick={handleUploadingSingleElement}>
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

  handleDeletingSingleElement(element) {
    if (this.state.configData.hasIn(['parameters', 'config', 'files'])) {
      let newConfig = this.state.configData.getIn(['parameters', 'config', 'files']).delete(element);
      this.updateParameters(newConfig);
    }
  },

  handleUploadingSingleElement(element) {
    console.log('uploading: ', element);
  },

  getInputTables() {
    return this.state.configData.getIn(['storage', 'input', 'tables']) || List();
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
    actions.updateLocalState(componentId, this.state.configId, newLocalState);
  }

});