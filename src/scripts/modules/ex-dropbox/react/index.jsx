import React from 'react';

import AuthorizationModal from './DropboxAuthorizationModal';
import FileSelectorModal from './DropboxFileSelectorModal';
import RunButtonModal from '../../components/react/components/RunComponentButton';

import classnames from 'classnames';
import ComponentDescription from '../../components/react/components/ComponentDescription';
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

import {
  getBucketsForSelection,
  getDestinationName,
  listBucketNames,
  filterBuckets,
  extractValues
} from '../actions/ApplicationActions';


const componentId = 'ex-dropbox';

export default React.createClass({

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

  getInitialState() {
    return {
      showAuthorizationModal: false,
      showFileSelectorModal: false
    };
  },

  openAuthorizationModal() {
    this.setState({
      showAuthorizationModal: true
    });
  },

  closeAuthorizationModal() {
    this.setState({
      showAuthorizationModal: false
    });
  },

  openFileSelectorModal() {
    this.setState({
      showFileSelectorModal: true
    });
  },

  closeFileSelectorModal() {
    this.setState({
      showFileSelectorModal: false
    });
  },

  componentDidMount() {
    if (this.state.hasCredentials) {
      let data = this.state.credentials.get('data');
      let token = JSON.parse(data).access_token;

      ExDropboxActions.getListOfCsvFiles(token);
      StorageActionCreators.loadBucketsForce();
      this.updateLocalState(['dropboxToken'], token);
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
        {this.renderFileSelectorModal()}
        {this.renderConfigSummary()}
        {this.renderDropboxLoginInformation()}
      </div>
    );
  },

  renderFileSelectorModal() {
    if (this.state.hasCredentials) {
      return (
        <div className="row component-empty-state text-right">
          <div>
            <a onClick={this.openFileSelectorModal}>
              <span className="btn btn-success">Configure Input Files</span>
            </a>
            <FileSelectorModal
              show={this.state.showFileSelectorModal}
              onHide={this.closeFileSelectorModal}
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
          </div>
        </div>
      );
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
                  <tr key={index}>
                      <td>{index + 1}.</td>
                      <td>{table}</td>
                      <td>{destinationFile}.{getDestinationName(table)}</td>
                      <td className="text-right">
                      <button className="btn btn-link" onClick={handleDeletingSingleElement}>
                        <i className="fa kbc-icon-cup"></i>
                      </button>
                      <RunButtonModal
                        title='Upload'
                        icon='fa fa-upload fa-fw'
                        mode='button'
                        component='ex-dropbox'
                        runParams={handleUploadingSingleElement}
                        >
                        You are about to run upload of <strong>1 csv file</strong> from your Dropbox.
                        The result will be stored into <strong>{this.state.configData.getIn(['parameters', 'config', 'bucket'])}</strong> bucket.
                      </RunButtonModal>
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

  renderDropboxLoginInformation() {
    if (!this.state.hasCredentials) {
      return (
        <div className="row component-empty-state text-center">
          <div>
            <p>No Dropbox account authorized!</p>
            <ModalTrigger modal={<AuthorizationModal configId={this.state.configId} />}>
              <span className="btn btn-success"><i className="fa fa-fw fa-dropbox"></i>Authorize Dropbox Account</span>
            </ModalTrigger>
          </div>
        </div>
      );
    }
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
              runParams={() => ({config: this.state.configId})}
              >
              You are about to run upload of <strong>{this.state.configData.getIn(['parameters', 'config', 'files'], List()).count()} csv files</strong> from your Dropbox.
              The result will be stored into <strong>{this.state.configData.getIn(['parameters', 'config', 'bucket'])}</strong> bucket.
            </RunButtonModal>
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

  renderResetAuthorization() {
    if (this.state.hasCredentials) {
      let description = this.state.credentials.get('description');
      return (
        <ActivateDeactivateButton
          mode='link'
          activateTooltip=''
          deactivateTooltip='Reset Authorization'
          isActive={true}
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
        <ModalTrigger modal={<AuthorizationModal configId={this.state.configId} />}>
          <span className="btn btn-link"><i className="fa fa-fw fa-user"></i>Authorize Dropbox Account</span>
        </ModalTrigger>
      );
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
    var filesData = this.state.localState.has('selectedDropboxFiles') ? List(fromJS(extractValues(this.state.localState.get('selectedDropboxFiles')))) : this.state.configData.getIn(['parameters', 'config', 'files']);

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
        selectedInputBucket.push({label: localConfigDataBucket, value: localConfigDataBucket});
      }
    }
    // Else handle a situation where some information about bucket is stored in configuration.
    else {
      // If no selection is made.
      // Return the configData information.
      if (!hasLocalConfigDataBucket) {
        selectedInputBucket.push({label: configDataBucket, value: configDataBucket});
      }
      // The last condition handle the situation where a update of bucket selection is made.
      // Return the local change.
      else {
        selectedInputBucket.push({label: localConfigDataBucket, value: localConfigDataBucket});
      }
    }

    return selectedInputBucket;
  },

  handleDeletingSingleElement(element) {
    if (this.state.configData.hasIn(['parameters', 'config', 'files'])) {
      let newConfig = this.state.configData.getIn(['parameters', 'config', 'files']).delete(element);
      this.updateAndSaveConfigData(['parameters', 'config', 'files'], newConfig);
    }
  },

  handleUploadingSingleElement(element) {
    if (this.state.configData.hasIn(['parameters', 'config', 'files'])) {
      return {
          configData: {
            parameters: {
            config: {
              files: [
                this.state.configData.getIn(['parameters', 'config', 'files']).get(element)
              ],
              bucket: this.state.configData.getIn(['parameters', 'config', 'bucket']),
              credentials: this.state.configData.getIn(['parameters', 'config', 'credentials'])
            }
          }
        }
      };
    }
  },

  getInputBuckets() {
    return getBucketsForSelection(listBucketNames(filterBuckets(this.state.keboolaBuckets)));
  },

  handleCsvSelectChange(value, values) {
    this.updateLocalState(['selectedDropboxFiles'], values);
  },

  handleInputBucketChange(value) {
    this.updateLocalState(['selectedInputBucket'], value);
  },

  deleteCredentials() {
    OAuthActions.deleteCredentials(componentId, this.state.configId);
  },

  updateLocalState(path, data) {
    let newLocalState = this.state.localState.setIn(path, data);
    actions.updateLocalState(componentId, this.state.configId, newLocalState);
  },

  cancelConfig() {
    console.log('CANCELING CONFIGURATION!');
  }
});