import React, {PropTypes} from 'react';
import filesize from 'filesize';
import _ from 'underscore';
import string from 'underscore.string';
import moment from 'moment';

import SapiTableLink from '../StorageApiTableLink';
import EmptyState from '../../../../components/react/components/ComponentEmptyState';
import date from '../../../../../utils/date';

import {TabbedArea, TabPane, Input, Table, Modal} from 'react-bootstrap';
import {RefreshIcon} from 'kbc-react-components';



export default React.createClass({

  propTypes: {
    show: PropTypes.bool.isRequired,
    tableId: PropTypes.string.isRequired,
    reload: PropTypes.func.isRequired,
    tableExists: PropTypes.bool.isRequired,
    omitFetches: PropTypes.bool,
    events: PropTypes.object.isRequired,
    omitExports: PropTypes.bool,
    isLoading: PropTypes.bool,
    table: PropTypes.object,
    dataPreview: PropTypes.object,
    onOmitFetchesFn: PropTypes.func,
    onOmitExportsFn: PropTypes.func,
    onHideFn: PropTypes.func


  },

  render(){
    const modalBody = this.renderModalBody();
    let tableLink = (<small className="disabled btn btn-link"> Explore in Console</small>);
    if (this.props.tableExists){
      tableLink =
      (
        <SapiTableLink
          tableId={this.props.tableId}>
          <small className="btn btn-link">
            Explore in Console
          </small>
        </SapiTableLink>);


    }
    return (
      <div className="static-modal">
        <Modal
          bsSize="large"
          show={this.props.show}
          onHide={this.props.onHideFn}
          >
          <Modal.Header closeButton>
            <Modal.Title>
              {this.props.tableId}
              {tableLink}
              <RefreshIcon
                 isLoading={this.props.isLoading}
                 onClick={this.props.reload}
              />
            </Modal.Title>
          </Modal.Header>
          <Modal.Body>
            {modalBody}
          </Modal.Body>
        </Modal>
      </div>
    );

  },

  renderEvents(){
    if (!this.props.tableExists){
      return (
        <EmptyState>
          No Data.
        </EmptyState>
      );
    }
    const events = this.props.events;
    const rows = events.map( (e) => {
      const event = e.get('event');
      let info = this.eventsTemplates[event];
      if (!info){
        info = {
          className: '',
          message: e.get('message')
        };
      }
      const cl = `tr ${info.className}`;
      const agoTime = moment(e.get('created')).fromNow();
      const incElement = (<p><small><strong>incremental</strong></small></p>);
      info.message = string.replaceAll(info.message, this.props.tableId, '');
      const incremental = e.getIn(['params', 'incremental']) ? incElement : (<span></span>);
      return (
        <tr className={cl}>
          <td className="td">
            {e.get('id')}
          </td>
          <td className="td">
            {date.format(e.get('created'))}
            <small> {agoTime} </small>
          </td>
          <td className="td">
            {e.get('component')}
          </td>
          <td className="td">
            {info.message}
            {incremental}
          </td>
          <td className="td">
            {e.getIn(['token', 'name'])}
          </td>
        </tr>
      );
    }
    );



    return (
      <span>
        <Input>
        <div className="col-xs-3">
          <div className="checkbox">
            <label>
              <input
                checked={this.props.omitFetches}
                onClick={this.props.onOmitFetchesFn}
                type="checkbox"/> Ignore table fetches
            </label>
          </div>
        </div>
        <div className="col-xs-3">
          <div className="checkbox">
            <label>
              <input
                 checked={this.props.omitExports}
                 onClick={this.props.onOmitExportsFn}
                 type="checkbox"/> Ignore table exports
            </label>
          </div>
        </div>
        </Input>

        <table className="table table-striped">
          <thead className="thead">
            <tr className="tr">
              <th className="th">
                Id
              </th>
              <th className="th">
                Created
              </th>
              <th className="th">
                Component
              </th>
              <th className="th">
                Event
              </th>
              <th className="th">
                Creator
              </th>

            </tr>
          </thead>
          <tbody className="tbody">
            {rows}
          </tbody>
        </table>
      </span>);
  },


  renderModalBody(){
    return (
      <TabbedArea key="tabbedarea" animation={false}>
        <TabPane key="general" eventKey="general" tab="General Info">
          {this.renderGeneralInfo()}
        </TabPane>
        <TabPane key="columns" eventKey="columns" tab="Columns">
          {this.renderColumnsInfo()}
        </TabPane>
        <TabPane key="datasample" eventKey="datasample" tab="Data Sample">
          {this.renderDataSample()}
        </TabPane>
        <TabPane key="events" eventKey="events" tab="Events">
          {this.renderEvents()}
        </TabPane>
      </TabbedArea>
    );

  },

  renderGeneralInfo(){
    if (!this.props.tableExists)
    {
      let msg = 'Table does not exist yet.';
      if (this.props.isLoading){
        msg = 'Loading...';
      }
      return (
        <EmptyState key="emptytable">
          {msg}
        </EmptyState>
      );

    }
    const table = this.props.table;
    const primaryKey = table.get('primaryKey').toJS();
    const indexes = table.get('indexedColumns').toJS();
    return (
      <div>
        <Table responsive className="table">
          <thead>
            <tr>
              <td style={{width: '20%'}}>
                ID
              </td>
              <td>
                {table.get('id')}
              </td>
            </tr>
          </thead>
          <tbody>
            {this.renderTableRow('Storage', table.get('bucket').get('backend'))}
            {this.renderTableRow('Created', this.renderTimefromNow(table.get('created')))}
            {this.renderTableRow('Primary Key', _.isEmpty(primaryKey) ? 'N/A' : primaryKey.join(', '))}
            {this.renderTableRow('Last Import', this.renderTimefromNow(table.get('lastImportDate')))}
            {this.renderTableRow('Last Change', this.renderTimefromNow(table.get('lastChangeDate')))}

            {this.renderTableRow('Rows Count', table.get('rowsCount') + ' rows')}
            {this.renderTableRow('Data Size', filesize(table.get('dataSizeBytes')))}
            {this.renderTableRow('Indexed Column(s)', _.isEmpty(indexes) ? 'N/A' : indexes.join(', '))}
            {this.renderTableRow('Columns', table.get('columns').count() + ' columns: ' + table.get('columns').join(', '))}
          </tbody>
        </Table>
      </div>
    );
  },

  renderColumnsInfo(){
    if (!this.props.tableExists || !this.isDataPreview()){
      return (
        <EmptyState>
          No Data.
        </EmptyState>
      );
    }
    const {table} = this.props;
    const columns = table.get('columns');

    const columnsRows = columns.map((c) => {
      const values = this.getColumnValues(c);
      let result = values.filter((val) => val !== '').join(', ');
      return this.renderTableRow(this.renderColumnHeader(c), result);
    });

    return (
      <div>
        <Table responsive className="table table-striped">
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
            {columnsRows}
          </tbody>
        </Table>
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


  renderDataSample(){
    const data = this.props.dataPreview;
    if (data.count() === 0){
      return (
        <EmptyState>
          No Data.
        </EmptyState>
      );
    }

    const header = data.first().map( (c) => {
      return (
        <th>
          {c}
        </th>
      );
    }).toArray();
    const rows = data.rest().map( (row) => {
      const cols = row.map( (c) => {
        return (<td> {c} </td>);
      });

      return (
        <tr>
          {cols}
        </tr>);
    });

    return (
      <div>
        <Table responsive className="table table-striped">
          <thead>
            <tr>
              {header}
            </tr>
          </thead>
          <tbody>
            {rows}
          </tbody>
        </Table>
      </div>
    );
  },


  renderColumnHeader(column){
    const {table} = this.props,
    indexed = table.get('indexedColumns'),
    primary = table.get('primaryKey');
    return (
      <span>
        {column}
        <div>
          {indexed.indexOf(column) > -1 ? ( <small><span className="label label-info">index</span></small>) : '' }
          {primary.indexOf(column) > -1 ? ( <small><span className="label label-info">PK</span></small>) : '' }
        </div>
      </span>
    );


  },


  eventsTemplates: {
    'storage.tableImportStarted': {
      'message': 'Import started',
      'className': ''
    },

    'storage.tableImportDone': {
      'message': 'Successfully imported ',
      'className': 'success'
    },

    'storage.tableImportError': {
      'message': 'Error on table import',
      'className': 'error'
    },

    'storage.tableExported': {
      'message': 'Exported to a csv file',
      'className': 'info'
    }

  },

  renderTimefromNow(value){
    const fromNow = moment(value).fromNow();
    return (
      <span> {date.format(value)}
        <small> {fromNow} </small>
      </span>
    );

  },

  getColumnValues(columnName){
    const data = this.props.dataPreview;
    const columnIndex = data.first().indexOf(columnName);

    const result = data
    .shift()
    .map( (row) => {
      return row.get(columnIndex);
    });
    return result;
  },


  isDataPreview(){
    return !_.isEmpty(this.props.dataPreview.toJS());
  }

});
