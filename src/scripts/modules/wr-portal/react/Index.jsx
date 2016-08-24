import React from 'react';
import {fromJS, Map} from 'immutable';

import createStoreMixin from '../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../stores/RoutesStore';
import InstalledComponentStore from '../../components/stores/InstalledComponentsStore';
import installedComponentsActions from '../../components/InstalledComponentsActionCreators';
import storageActions from '../../components/StorageActionCreators';
import BucketStore from '../../components/stores/StorageBucketsStore';

import EmptyState from '../../components/react/components/ComponentEmptyState';
import ComponentDescription from '../../components/react/components/ComponentDescription';
import {Loader} from 'kbc-react-components';
import Confirm from '../../../react/common/Confirm';
import ComponentMetadata from '../../components/react/components/ComponentMetadata';
import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';
import Credentials from './Credentials';
import SelectBucket from './SelectBucket';
import HowtoModal from './HowtoModal.jsx';
/* import LatestJobsStore from '../../jobs/stores/LatestJobsStore'; */
/* import storageTablesStore from '../../components/stores/StorageTablesStore'; */

/* const componentId = 'wr-portal-sas'; */

export default function(componentId) {
  return React.createClass({
    mixins: [createStoreMixin(InstalledComponentStore, BucketStore)],

    getStateFromStores() {
      const configId = RoutesStore.getCurrentRouteParam('config');
      const localState = InstalledComponentStore.getLocalState(componentId, configId);
      const configData = InstalledComponentStore.getConfigData(componentId, configId);
      const bucketId = configData.get('bucketId');
      const credentialsId = configData.get('id');
      const isCreatingCredentials = BucketStore.isCreatingCredentials(bucketId);
      const isDeletingCredentials = BucketStore.isDeletingCredentials(bucketId);
      const credentialsExist = bucketId && !!BucketStore.getCredentials(bucketId).find((c) => c.get('id') === credentialsId);
      return {
        credentialsExist: credentialsExist,
        bucketId: bucketId,
        credentialsId: credentialsId,
        isDeleting: isDeletingCredentials,
        isCreating: isCreatingCredentials,
        configId: configId,
        localState: localState || Map(),
        configData: configData,
        isConfigSaving: InstalledComponentStore.isSavingConfigData(componentId, configId)
      };
    },

    onSelectBucket(bucketId) {
      const name = `${componentId}#${this.state.configId}`;
      storageActions.createCredentials(bucketId, name).then((credentials) => {
        let newData = fromJS(credentials.redshift);
        newData = newData.set('bucketId', bucketId).set('id', credentials.id);
        /* save credentias id to config data and close modal */
        installedComponentsActions.saveComponentConfigData(componentId, this.state.configId, newData).then(() => this.updateLocalState(['bucket'], Map()));
      });
    },

    render() {
      return (
        <div className="container-fluid">
          <div className="col-md-9 kbc-main-content">
            <div className="row kbc-header">
              <ComponentDescription
                componentId={componentId}
                configId={this.state.configId}
              />
            </div>
            <div className="row">
              {this.renderContent()}
            </div>
          </div>
          {this.renderSideBar()}
        </div>
      );
    },

    renderContent() {
      if (this.state.credentialsExist) {
        return (
          <Credentials
            credentials={this.state.configData}
            isCreating={this.state.isCreating}
          />
        );
      } else {
        return (
          <EmptyState>
            <p> Select a bucket to connect to.</p>
            <SelectBucket
              localState={this.state.localState.get('bucket', Map())}
              setState={(key, value) => this.updateLocalState(['bucket'].concat(key), value)}
              selectBucketFn={this.onSelectBucket}
              isSaving={this.state.isCreating || this.state.isConfigSaving}
            />
          </EmptyState>
        );
      }
    },

    renderSideBar() {
      return (
        <div className="col-md-3 kbc-main-sidebar">
          <div classNmae="kbc-buttons kbc-text-light">
            <ComponentMetadata
              componentId={componentId}
              configId={this.state.configId}
            />
          </div>
          <ul className="nav nav-stacked">
            <li>
              {this.renderHowto()}
            </li>
            <li>
              <DeleteConfigurationButton
                componentId={componentId}
                configId={this.state.configId}
              />
            </li>
            {this.renderResetLink()}
          </ul>
        </div>
      );
    },

    renderHowto() {
      return (
          <a onClick={() => this.updateLocalState(['showHowto'], true)}>
            <span className="fa fa-question-circle fa-fw"/>
            How To Connect
            <HowtoModal
              show={!!this.state.localState.get('showHowto')}
              onHide={() => this.updateLocalState(['showHowto'], false)}
              componentId={componentId}
            />
          </a>
      );
    },

    renderResetLink() {
      if (!this.state.credentialsExist) {
        return null;
      }
      let content = (
        <Confirm
          text="You are about to delete the credentials"
          title="Delete Credentials"
          buttonLabel="Delete"
          buttonType="danger"
          onConfirm={this.resetCredentials}
        >
          <a>
            <span className="fa fa-times fa-fw"/>
            Delete Credentials
          </a>
        </Confirm>);
      if (this.state.isDeleting) {
        content = (
          <a>
            <Loader/>

            {' Deleting...'}
          </a>
        );
      }
      return (
        <li>
          {content}
        </li>
      );
    },

    resetCredentials() {
      const bucketId = this.state.configData.get('bucketId');
      const credentialsId = this.state.configData.get('id');
      storageActions.deleteCredentials(bucketId, credentialsId).then(() => {
        return installedComponentsActions.saveComponentConfigData(componentId, this.state.configId, Map());
      });
    },

    updateLocalState(path, newData) {
      const newState = this.state.localState.setIn(path, newData);
      installedComponentsActions.updateLocalState(componentId, this.state.configId, newState, path);
    }

  });
}
