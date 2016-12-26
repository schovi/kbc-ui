import React from 'react';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RStudioSandboxCredentialsStore from '../../../provisioning/stores/RStudioSandboxCredentialsStore';
import CredentialsActionCreators from '../../../provisioning/ActionCreators';
import RStudioCredentials from '../../../provisioning/react/components/RStudioCredentials';
// import ConfigureSandbox from '../components/ConfigureSandbox';
// import RunComponentButton from '../../../components/react/components/RunComponentButton';
import DeleteButton from '../../../../react/common/DeleteButton';
import StorageBucketsStore from '../../../components/stores/StorageBucketsStore';
import StorageTablesStore from '../../../components/stores/StorageTablesStore';

var RStudioSandbox = React.createClass({
  mixins: [createStoreMixin(RStudioSandboxCredentialsStore, StorageBucketsStore, StorageTablesStore)],
  displayName: 'RStudioSandbox',
  getStateFromStores: function() {
    return {
      credentials: RStudioSandboxCredentialsStore.getCredentials(),
      pendingActions: RStudioSandboxCredentialsStore.getPendingActions(),
      isLoading: RStudioSandboxCredentialsStore.getIsLoading(),
      isLoaded: RStudioSandboxCredentialsStore.getIsLoaded(),
      tables: StorageTablesStore.getAll(),
      buckets: StorageBucketsStore.getAll()
    };
  },
  _renderCredentials: function() {
    return (
      <span>
        <RStudioCredentials
          credentials={this.state.credentials}
          isCreating={this.state.pendingActions.get('create')}
        />
      </span>
    );
  },
  _renderControlButtons: function() {
    const connectLink = 'http://' + this.state.credentials.get('hostname') + ':' + this.state.credentials.get('port');
    if (this.state.credentials.get('id')) {
      return (
        <div>
          <div>
            <a
              href={connectLink}
              className="btn btn-link"
              target="_blank"
              disabled={this.state.pendingActions.get('drop')}
            >
              <span className="fa fa-fw fa-database"></span>
              &nbsp;Connect
            </a>
            <div>
              <DeleteButton
                tooltip="Delete RStudio Sandbox"
                isPending={this.state.pendingActions.get('drop')}
                label="Drop sandbox"
                fixedWidth={true}
                confirm={{
                  title: 'Delete RStudio Sandbox',
                  text: 'Do you really want to delete RStudio sandbox?',
                  onConfirm: this._dropCredentials
                }}
              />
            </div>
          </div>
        </div>
      );
    } else if (!this.state.pendingActions.get('create')) {
      return (
        <button
          className="btn btn-link"
          onClick={this._createCredentials}
        >
          <i className="fa fa-fw fa-plus"></i>
          &nbsp;Create sandbox
        </button>
      );
    }
  },
  render: function() {
    return (
      <div className="row">
        <h4>RStudio</h4>
        <div className="col-md-9">
          {this._renderCredentials()}
        </div>
        <div className="col-md-3">
          {this._renderControlButtons()}
        </div>
      </div>
    );
  },
  _createCredentials: function() {
    return CredentialsActionCreators.createRStudioSandboxCredentials();
  },
  _dropCredentials: function() {
    return CredentialsActionCreators.dropRStudioSandboxCredentials();
  }
});

module.exports = RStudioSandbox;
