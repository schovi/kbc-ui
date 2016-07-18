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
import UploadStatic from '../components/UploadStatic';
import UploadEdit from '../components/UploadEdit';

// global components
import ComponentDescription from '../../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../../components/react/components/ComponentMetadata';
import DeleteConfigurationButton from '../../../components/react/components/DeleteConfigurationButton';
import EditButtons from '../../../../react/common/EditButtons';

// CONSTS
const COMPONENT_ID = 'keboola.csv-import';

/*

notes

- vpravo by to mohlo ukazovat importní joby storage (nevím jak)
- upload do S3 pomocí https://www.npmjs.com/package/react-s3-uploader
- postup
  - create file resource - http://docs.keboola.apiary.io/#reference/files/upload-file/upload-arbitrary-file-to-keboola
  - upload to S3
  - (list tables) create or update
  - progress
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
      isUploaderValid: store.isUploaderValid,
      localState: store.getLocalState(),
      destination: store.destination,
      tables: StorageTablesStore.getAll()
    };
  },

  renderEditButtons() {
    return React.createElement(EditButtons, {
      isEditing: this.state.localState.get('isEditing'),
      isSaving: this.state.localState.get('isSaving'),
      editLabel: 'Edit Settings',
      onCancel: this.state.actions.editCancel,
      onSave: this.state.actions.editSave,
      onEditStart: this.state.actions.editStart
    });
  },

  renderEditForm() {
    if (this.state.localState.get('isEditing')) {
      return (
        <UploadEdit
          settings={this.state.localState.get('settings')}
          onChange={this.state.actions.editChange}
          tables={this.state.tables}
        />
      );
    }
  },

  renderUploadForm() {
    if (this.state.localState.get('isEditing')) {
      return null;
    } else {
      return (
        <UploadStatic
          destination={this.state.destination}
          incremental={true}
          primaryKey={['Id', 'Name']}
          onStartUpload={this.state.actions.startUpload}
          onChange={this.state.actions.setFile}
          isValid={this.state.isUploaderValid}
          isUploading={this.state.localState.get('isUploading')}
          uploadingMessage={this.state.localState.get('uploadingMessage')}
        />
      );
    }
  },

  render() {
    return (
      <div className="container-fluid">
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <div className="col-sm-10">
              <ComponentDescription
                componentId={COMPONENT_ID}
                configId={this.state.configId}
              />
            </div>
          </div>
          <div className="row">
            {this.renderUploadForm()}
            {this.renderEditForm()}
            {this.renderEditButtons()}
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
        </div>
      </div>

    );
  }
});
