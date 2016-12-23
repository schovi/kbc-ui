import React from 'react';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import SnowflakeSandboxCredentialsStore from '../../../provisioning/stores/SnowflakeSandboxCredentialsStore';
import CredentialsActionCreators from '../../../provisioning/ActionCreators';
import SnowflakeCredentials from '../../../provisioning/react/components/SnowflakeCredentials';
import ConfigureSandbox from '../components/ConfigureSandbox';
import RunComponentButton from '../../../components/react/components/RunComponentButton';
import DeleteButton from '../../../../react/common/DeleteButton';
import StorageBucketsStore from '../../../components/stores/StorageBucketsStore';
import StorageTablesStore from '../../../components/stores/StorageTablesStore';

var SnowflakeSandbox = React.createClass({
  mixins: [createStoreMixin(SnowflakeSandboxCredentialsStore, StorageBucketsStore, StorageTablesStore)],
  displayName: 'RStudioSandbox',
  getStateFromStores: function() {
    return {
      credentials: SnowflakeSandboxCredentialsStore.getCredentials(),
      pendingActions: SnowflakeSandboxCredentialsStore.getPendingActions(),
      isLoading: SnowflakeSandboxCredentialsStore.getIsLoading(),
      isLoaded: SnowflakeSandboxCredentialsStore.getIsLoaded(),
      tables: StorageTablesStore.getAll(),
      buckets: StorageBucketsStore.getAll()
    };
  },
  _renderCredentials: function() {
    return (
      <span>
        <SnowflakeCredentials
          credentials={this.state.credentials}
          isCreating={this.state.pendingActions.get('create')}
        />
      </span>
    );
  },
  _renderControlButtons: function() {
    var sandboxConfiguration;
    if (this.state.credentials.get('id')) {
      sandboxConfiguration = {};
      return (
        <div>
          <div>
            <RunComponentButton
              title="Load tables into Snowflake sandbox"
              component="transformation"
              method="create-sandbox"
              mode="button"
              label="Load data"
              runParams={() => {
                return sandboxConfiguration;
              }}
            >
                <ConfigureSandbox
                  backend="snowflake"
                  tables={this.state.tables}
                  buckets={this.state.buckets}
                  onChange={(params) => {
                    sandboxConfiguration = params;
                  }}/>
              </RunComponentButton>
          </div>
          <div>
            <a
              href="https://#{this.state.credentials.get('hostname')}"
              className="btn btn-link"
              target="_blank"
            >
              <span className="fa fa-fw fa-database"></span>
              &nbsp;Connect
            </a>
            <div>
              <DeleteButton
                tooltip="Delete Snowflake Sandbox"
                isPending={this.state.pendingActions.get('drop')}
                label="Drop sandbox"
                fixedWidth={true}
                confirm={{
                  title: 'Delete Snowflake Sandbox',
                  text: 'Do you really want to delete Snowflake sandbox?',
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
        <h4>Snowflake</h4>
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
    return CredentialsActionCreators.createSnowflakeSandboxCredentials();
  },
  _dropCredentials: function() {
    return CredentialsActionCreators.dropSnowflakeSandboxCredentials();
  }
});

module.exports = SnowflakeSandbox;
