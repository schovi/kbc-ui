import React from 'react';

// stores
import ComponentStore from '../../../components/stores/ComponentsStore';
import InstalledComponentsStore from '../../../components/stores/InstalledComponentsStore';
import StorageTablesStore from '../../../components/stores/StorageTablesStore';
import StorageBucketsStore from '../../../components/stores/StorageBucketsStore';
import RoutesStore from '../../../../stores/RoutesStore';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import storeProvisioning from '../../storeProvisioning';

// actions
import actionsProvisioning from '../../actionsProvisioning';

// specific components
import Upload from '../components/Upload';
import SettingsStatic from '../components/SettingsStatic';
import SettingsEdit from '../components/SettingsEdit';

// global components
import ComponentDescription from '../../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../../components/react/components/ComponentMetadata';
import DeleteConfigurationButton from '../../../components/react/components/DeleteConfigurationButton';
import LatestVersions from '../../../components/react/components/SidebarVersionsWrapper';

// utils
import {getDefaultTable} from '../../utils';
import {Map} from 'immutable';

// CONSTS
const COMPONENT_ID = 'keboola.csv-import';

/*

notes

- vpravo by to mohlo ukazovat importní joby storage (nevím jak)

 */

export default React.createClass({
  // TODO ještě store na joby ve storage
  mixins: [createStoreMixin(InstalledComponentsStore, StorageTablesStore, StorageBucketsStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config');
    const component = ComponentStore.getComponent(COMPONENT_ID);
    const store = storeProvisioning(configId);
    const actions = actionsProvisioning(configId);
    return {
      component: component,
      configId: configId,
      actions: actions,
      tables: StorageTablesStore.getAll(),
      isUploaderValid: store.isUploaderValid,
      isUploaderFileTooBig: store.isUploaderFileTooBig,
      isUploaderFileInvalidFormat: store.isUploaderFileInvalidFormat,
      localState: store.getLocalState(),
      destination: store.destination,
      incremental: store.incremental,
      primaryKey: store.primaryKey,
      delimiter: store.delimiter,
      enclosure: store.enclosure
    };
  },

  renderUploader() {
    if (!this.state.localState.get('isEditing')) {
      return (
        <Upload
          onStartUpload={this.state.actions.startUpload}
          onChange={this.state.actions.setFile}
          isValid={this.state.isUploaderValid}
          isFileTooBig={this.state.isUploaderFileTooBig}
          isFileInvalidFormat={this.state.isUploaderFileInvalidFormat}
          isUploading={this.state.localState.get('isUploading', false)}
          uploadingMessage={this.state.localState.get('uploadingMessage', '')}
          uploadingProgress={this.state.localState.get('uploadingProgress', 0)}
          key={this.state.localState.get('fileInputKey', 0)}
          resultMessage={this.state.localState.get('resultMessage', '')}
          resultState={this.state.localState.get('resultState', '')}
          onDismissResult={this.state.actions.dismissResult}
        />
      );
    }
    return null;
  },

  renderSettings() {
    if (this.state.localState.get('isEditing')) {
      return (
        <SettingsEdit
          settings={this.state.localState.get('settings', Map())}
          onChange={this.state.actions.editChange}
          tables={this.state.tables}
          defaultTable={getDefaultTable(this.state.configId)}
          onCancel={this.state.actions.editCancel}
          onSave={this.state.actions.editSave}
          isSaving={this.state.localState.get('isSaving', false)}
        />
      );
    } else {
      return (
        <SettingsStatic
          destination={this.state.destination}
          incremental={this.state.incremental}
          primaryKey={this.state.primaryKey}
          delimiter={this.state.delimiter}
          enclosure={this.state.enclosure}
          onStartChangeSettings={this.state.actions.editStart}
          isEditDisabled={this.state.localState.get('isUploading', false)}
        />
      );
    }
  },

  render() {
    return (
      <div className="container-fluid">
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <div className="col-sm-12">
              <ComponentDescription
                componentId={COMPONENT_ID}
                configId={this.state.configId}
              />
            </div>
          </div>
          <div className="row">
            {this.renderUploader()}
            {this.renderSettings()}
          </div>
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <ComponentMetadata
            componentId={COMPONENT_ID}
            configId={this.state.configId}
          />
          <ul className="nav nav-stacked">
            <li>
              <DeleteConfigurationButton
                componentId={COMPONENT_ID}
                configId={this.state.configId}
              />
            </li>
          </ul>
          <LatestVersions
            componentId="keboola.csv-import"
          />
        </div>
      </div>

    );
  }
});
