import React from 'react';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import JupyterSandboxCredentialsStore from '../../../provisioning/stores/JupyterSandboxCredentialsStore';
import CredentialsActionCreators from '../../../provisioning/ActionCreators';
import JupyterCredentials from '../../../provisioning/react/components/JupyterCredentials';
import DeleteButton from '../../../../react/common/DeleteButton';
import StorageBucketsStore from '../../../components/stores/StorageBucketsStore';
import StorageTablesStore from '../../../components/stores/StorageTablesStore';
import CreateDockerSandboxModal from '../modals/CreateDockerSandboxModal';

var JupyterSandbox = React.createClass({
  mixins: [createStoreMixin(JupyterSandboxCredentialsStore, StorageBucketsStore, StorageTablesStore)],
  displayName: 'JupyterSandbox',
  getStateFromStores: function() {
    return {
      credentials: JupyterSandboxCredentialsStore.getCredentials(),
      pendingActions: JupyterSandboxCredentialsStore.getPendingActions(),
      isLoading: JupyterSandboxCredentialsStore.getIsLoading(),
      isLoaded: JupyterSandboxCredentialsStore.getIsLoaded(),
      tables: StorageTablesStore.getAll(),
      buckets: StorageBucketsStore.getAll()
    };
  },
  getInitialState() {
    return {
      showModal: false,
      sandboxConfiguration: {}
    };
  },
  _renderCredentials: function() {
    return (
      <span>
        <JupyterCredentials
          credentials={this.state.credentials}
          isCreating={this.state.pendingActions.get('create')}
        />
      </span>
    );
  },
  _renderControlButtons: function() {
    const connectLink = 'http://' + this.state.credentials.get('hostname') + ':' + this.state.credentials.get('port') + '/notebooks/notebook.ipynb';
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
                tooltip="Delete Jupyter Sandbox"
                isPending={this.state.pendingActions.get('drop')}
                label="Drop sandbox"
                fixedWidth={true}
                confirm={{
                  title: 'Delete Jupyter Sandbox',
                  text: 'Do you really want to delete Jupyter sandbox?',
                  onConfirm: this._dropCredentials
                }}
              />
            </div>
          </div>
        </div>
      );
    } else if (!this.state.pendingActions.get('create')) {
      return (
        <span>
          <CreateDockerSandboxModal
            show={this.state.showModal}
            close={this.closeModal}
            create={this._createCredentials}
            tables={this.tablesList()}
            type="Jupyter"
            onConfigurationChange={this.onConfigurationChange}
          />
          <button
            className="btn btn-link"
            onClick={this.openModal}
          >
            <i className="fa fa-fw fa-plus"></i>
            &nbsp;Create sandbox
          </button>
        </span>
      );
    }
  },
  render: function() {
    return (
      <div className="row">
        <h4>Jupyter</h4>
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
    return CredentialsActionCreators.createJupyterSandboxCredentials(this.state.sandboxConfiguration);
  },
  _dropCredentials: function() {
    return CredentialsActionCreators.dropJupyterSandboxCredentials();
  },
  closeModal() {
    this.setState({ showModal: false });
  },
  openModal() {
    this.setState({ showModal: true });
  },
  onConfigurationChange(configuration) {
    this.setState({sandboxConfiguration: configuration});
  },
  tablesList() {
    return this.state.tables.map(function(table) {
      return table.get('id');
    }).toList();
  }
});

module.exports = JupyterSandbox;
