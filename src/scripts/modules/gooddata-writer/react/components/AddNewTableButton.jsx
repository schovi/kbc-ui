import React from 'react';
import {Map} from 'immutable';


import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../../stores/RoutesStore';
import InstalledComponentStore from '../../../components/stores/InstalledComponentsStore';
import {Loader} from 'kbc-react-components';
import SapiTableSelector from  '../../../components/react/components/SapiTableSelector';
//import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import {Button, Modal, Input} from 'react-bootstrap';

import installedComponentsActions from '../../../components/InstalledComponentsActionCreators';

const componentId = 'gooddata-writer';


export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
          localState = InstalledComponentStore.getLocalState(componentId, configId);

    return {
      configId: configId,
      localState: localState.get('newTable', Map()),
      componentLocalState: localState
    };
  },


  render() {
    return (
      <span>
        {this.renderButton()}
        {this.renderModal()}
      </span>
    );
  },

  renderModal() {
    return (
      <Modal show={this.state.localState.get('show', false)} onHide={this.close}>
        <Modal.Header>
          <Modal.Title> Add New Table </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {this.renderBody()}
        </Modal.Body>
        <Modal.Footer>
          {false ? <Loader/> : null}
          <Button bsStyle="link" onClick={this.close}>Close</Button>
          <Button bsStyle="primary"
                  disabled={false}
                  onClick={() => this.onAddNewTable()}>
            Change
          </Button>
        </Modal.Footer>
      </Modal>
    );
  },

  renderButton() {
    return (
      <Button
          onClick={this.onAddNewTableButtonClick}
          bsStyle="success">
        + Add New Table
      </Button>
    );
  },

  renderBody() {
    const sapiSelector = (
      <SapiTableSelector
          onSelectTableFn={(e) => this.updateLocalState(['value'], e)}
          value={this.state.localState.get('value')}
          allowedBuckets={['out']}
          placeholder="out.c-main.data" />
    );
    return (
      <div className="form form-horizontal">
        {this.renderFormElement('Storage Table', sapiSelector)}
      </div>
    );
  },

  renderFormElement(label, element, description = '', hasError = false) {
    let errorClass = 'form-group';
    if (hasError) {
      errorClass = 'form-group has-error';
    }

    return (
      <div className={errorClass}>
        <label className="control-label col-sm-3">
          {label}
        </label>
        <div className="col-sm-9">
          {element}
          <span className="help-block">{description}</span>
        </div>
      </div>
    );
  },


  onAddNewTableButtonClick() {
    this.updateLocalState(['show'], true);
  },

  close() {
    this.updateLocalState(['show'], false);
  },

  updateLocalState(path, data) {
    const newState = this.state.componentLocalState.setIn(['newTable'].concat(path), data);
    installedComponentsActions.updateLocalState(componentId, this.state.configId, newState);
  }

});
