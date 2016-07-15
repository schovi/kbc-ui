import React from 'react';

// stores
import ComponentStore from '../../../components/stores/ComponentsStore';
import InstalledComponentsStore from '../../../components/stores/InstalledComponentsStore';
import RoutesStore from '../../../../stores/RoutesStore';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import storeProvisioning from '../../storeProvisioning';

// actions
import actionsProvisioning from '../../actionsProvisioning';

// specific components
import UploadStatic from '../components/UploadStatic';

// global components
import ComponentDescription from '../../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../../components/react/components/ComponentMetadata';
import DeleteConfigurationButton from '../../../components/react/components/DeleteConfigurationButton';

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

  mixins: [createStoreMixin(InstalledComponentsStore)],

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
      destination: store.destination
    };
  },

  setFile(file) {
    this.state.actions.updateLocalState(['file'], file);
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
            <UploadStatic
              destination={this.state.destination}
              incremental={true}
              primaryKey={['Id', 'Name']}
              onStartUpload={this.state.actions.startUpload}
              onChange={this.setFile}
              isValid={this.state.isUploaderValid}
            />
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
