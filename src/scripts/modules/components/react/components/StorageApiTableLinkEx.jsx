import React from 'react';
import Immutable from 'immutable';
import _ from 'underscore';

import {Modal, Button} from 'react-bootstrap';
import {TabbedArea, TabPane} from 'react-bootstrap';
import Tooltip from '../../../../react/common/Tooltip';
import {Loader} from 'kbc-react-components';
import SapiTableLink from './StorageApiTableLink';
import date from '../../../../utils/date';
import filesize from 'filesize';

import storageActions from '../../StorageActionCreators';
import storageApi from '../../StorageApi';

import tablesStore from '../../stores/StorageTablesStore';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';

export default React.createClass({

  mixins: [createStoreMixin(tablesStore)],

  propTypes: {
    tableId: React.PropTypes.string.isRequired,
    linkLabel: React.PropTypes.string
  },

  getStateFromStores(){
    const isLoading = tablesStore.getIsLoading();
    let table = null;
    if(!isLoading){
      table = tablesStore.getAll().get(this.props.tableId);
    }
    return {
      table: table,
      isLoading: isLoading
    };
  },

  componentDidMount(){
    storageActions.loadTables().then(() => this.exportDataSample());

  },

  exportDataSample(){
    const component = this;
    storageApi
    .exportTable(this.props.tableId, {limit: 10})
    .then( (csv) => {
      component.setState({
        loadingPreview: false,
        dataPreview: csv
      });
    });

  },

  getInitialState(){
    return ({
      show: false,
      dataPreview: null,
      loadingPreview: true
    });
  },

  render(){
    return (
      <span>
        <Tooltip
          tooltip={this.renderTooltip()}
          placement="top">
          {this.renderLink()}
        </Tooltip>
        {this.renderModal()}
      </span>
    );

  },

  renderLink(){
    return (
      <Button
        bsStyle="link"
        onClick={this.onShow}>
        {this.props.linkLabel || this.props.tableId}
      </Button>);

  },

  renderModalBody(){
    return (
      <TabbedArea animation={false}>
        <TabPane eventKey="general" tab="General Info">
          {this.renderGeneralInfo()}
        </TabPane>
        <TabPane eventKey="columns" tab="Columns">
          {this.renderColumnsInfo()}
        </TabPane>
      </TabbedArea>
    );

  },

  renderColumnsInfo(){
    if (this.state.loadingPreview){
      return (
        <div>
          <Loader/>
        </div>
      );
    }
    const {table} = this.state;
    const columns = table.get('columns').map((c) => {
      const values = this.getColumnValues(c);
      return this.renderTableRow(c, values.join(' ,'));
    });

    return (
      <div>
        <table className="table table-stripped">
          <thead>
            <tr>
              <th>
                Column
              </th>
              <th>
                Sample Values
              </th>
            </tr>
          </thead>
          <tbody>
            {columns}
          </tbody>
        </table>
      </div>
    );
  },

  renderGeneralInfo(){
    const table = this.state.table;
    const primaryKey = table.get('primaryKey').toJS();
    const indexes = table.get('indexedColumns').toJS();
    return (
      <div>
        <table className="table table-stripped">
          <tbody>
            {this.renderTableRow('ID', table.get('id'))}
            {this.renderTableRow('Created', date.format(table.get('created')))}
            {this.renderTableRow('Primary Key', _.isEmpty(primaryKey) ? 'N/A' : primaryKey.join(','))}
            {this.renderTableRow('Last Import', date.format(table.get('lastImportDate')))}
            {this.renderTableRow('Last Change', date.format(table.get('lastChangeDate')))}

            {this.renderTableRow('Rows Count', table.get('rowsCount') + ' rows')}
            {this.renderTableRow('Data Size', filesize(table.get('dataSizeBytes')))}
            {this.renderTableRow('Columns Count', table.get('columns').count() + ' columns')}

            {this.renderTableRow('Indexed Column(s)', _.isEmpty(indexes) ? 'N/A' : indexes.join(' ,'))}
          </tbody>
        </table>
      </div>
    );
  },

  renderTableRow(name, value){
    return (
      <tr>
        <td>
          {name}
        </td>
        <td>
          {value}
        </td>
      </tr>
    );

  },

  renderModal(){
    let modalBody = null;
    if (this.state.isLoading){
      modalBody = (<Loader />);
    }
    else{
      modalBody = this.renderModalBody();
    }

    return (
      <div className="static-modal">
        <Modal
          show={this.state.show}
          onHide={this.onHide}
          >
          <Modal.Header closeButton>
            <Modal.Title>
              {this.props.tableId}
              <SapiTableLink
                 tableId={this.props.tableId}>
                  <small className="btn btn-link">
                    Explore in Console
                  </small>
              </SapiTableLink>
            </Modal.Title>
          </Modal.Header>
          <Modal.Body>
            {modalBody}
          </Modal.Body>
          <Modal.Footer>
            <Button onClick={this.onHide}>Close</Button>
          </Modal.Footer>
        </Modal>
      </div>
    );
  },


  renderTooltip(){
    const table = this.state.table;
    return (
      <span>
        <div>
          {date.format(table.get('lastChangeDate'))}
        </div>
        <div>
          {filesize(table.get('dataSizeBytes'))}
        </div>
        <div>
          {table.get('rowsCount')} rows
        </div>
      </span>
    );
  },

  onHide(){
    this.setState({show: false});
  },

  onShow(){
    this.setState({show: true});
  },


  getColumnValues(columnName){
    const data = Immutable.fromJS(this.state.dataPreview);
    const columnIndex = data.first().indexOf(columnName);

    const result = data
    .shift()
    .map( (row) => {
      return row.get(columnIndex);
    });
    return result;
  }




});
