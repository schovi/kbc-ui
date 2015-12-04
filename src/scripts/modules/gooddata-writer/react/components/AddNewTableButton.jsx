import React from 'react';
import {Map, fromJS} from 'immutable';
import _ from 'underscore';


import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../../stores/RoutesStore';
import InstalledComponentStore from '../../../components/stores/InstalledComponentsStore';
import writerStore from '../../store';
import {Loader} from 'kbc-react-components';
import SapiTableSelector from  '../../../components/react/components/SapiTableSelector';
import {Button, Modal} from 'react-bootstrap';

import installedComponentsActions from '../../../components/InstalledComponentsActionCreators';
import writerActions from '../../actionCreators';

const componentId = 'gooddata-writer';


export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, writerStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      localState = InstalledComponentStore.getLocalState(componentId, configId);

    return {
      configuredTables: writerStore.getWriterTablesByBucket(configId),
      configId: configId,
      localState: localState.get('newTable', Map()),
      componentLocalState: localState,
      isSaving: writerStore.isAddingNewTable(configId)
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
          {this.state.isSaving ? <Loader/> : null}
          <Button bsStyle="link" onClick={this.close}>Cancel</Button>
          <Button bsStyle="success"
                  disabled={this.state.isSaving || !this.isValid()}
                  onClick={() => this.saveNewTable()}>
            Add
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
    const data = this.state.localState;
    const sapiSelector = (
      <SapiTableSelector
          onSelectTableFn={(e) => {
            let tmpData = this.state.localState;
            tmpData = tmpData.set('title', e);
            tmpData = tmpData.set('value', e);
            this.updateLocalState([], tmpData);
          }
          }
          value={this.state.localState.get('value')}
          allowedBuckets={['out']}
          excludeTableFn={this.isTableConfigured}
          placeholder="out.c-main.data" />
    );
    return (
      <div className="form form-horizontal">
        {this.renderFormElement('Storage Table', sapiSelector)}
        {this.renderFormElement('Title',
                                (<input
                                     className="form-control"
                                     value={data.get('title')}
                                     onChange={this.valueSetter('title')}/>))}
        {this.renderFormElement('Identifier',
                                (<input
                                     placeholder="optional"
                                     className="form-control"
                                     value={data.get('identifier')}
                                     onChange={this.valueSetter('identifier')}/>))}
      </div>
    );
  },

  isTableConfigured(tableId) {
    return this.state.configuredTables.has(tableId);
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

  isValid() {
    const data = this.state.localState;
    return !(_.isEmpty(data.get('title')) || _.isEmpty(data.get('value')));
  },

  valueSetter(key) {
    return (event) => {
      this.updateLocalState([key], event.target.value);
    };
  },
  onAddNewTableButtonClick() {
    this.updateLocalState(['show'], true);
  },

  saveNewTable() {
    const tableId = this.state.localState.get('value');
    const data = fromJS({
      title: this.state.localState.get('title'),
      identifier: this.state.localState.get('identifier')
    });
    writerActions.addNewTable(this.state.configId, tableId, data).then( () =>
      this.close()
    );
  },

  close() {
    this.updateLocalState([], Map());
  },

  updateLocalState(path, data) {
    const newState = this.state.componentLocalState.setIn(['newTable'].concat(path), data);
    installedComponentsActions.updateLocalState(componentId, this.state.configId, newState);
  }

});
