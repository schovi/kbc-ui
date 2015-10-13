import React, {PropTypes} from 'react';
import _ from 'underscore';

import EmptyState from '../../../../components/react/components/ComponentEmptyState';
import immutableMixin from '../../../../../react/mixins/ImmutableRendererMixin';

import {Table} from 'react-bootstrap';

const enhancedColumnsDescription = {
  'data_type': {
    name: 'Data Type',
    desc: 'desc',
    formatFn: (value, rowValues) => {
      const format = _.find(rowValues, r => r.name === 'format').value;
      const ists = _.find(rowValues, r => r.name === 'is_ts').value;
      const result = format ? `${value} (${format})` : `${value}`;
      const tsRender = (<small><span className="label label-info">Timeseries</span></small>);
      return ists === '1' ? (<span><div>{result}</div>{tsRender}</span>) : result;
    }

  },

  'format': { // merged to data_type
    name: 'Format',
    skip: true


  },

  'is_ts': { //merged to data_type
    name: 'Is ts',
    skip: true

  },

  'val_ratio': {
    name: 'Value Ratio',
    desc: '',
    formatFn: (value) => {
      return ((parseFloat(value)) * 100).toFixed(2);
    }

  },

  'is_identity': {
    name: 'Is Identity',
    desc: ''

  },

  'mode': {
    name: 'Mode',
    desc: ''

  },

  'monotonic': {
    name: 'Monotonic',
    desc: ''

  }
};

export default React.createClass({
  propTypes: {
    tableExists: PropTypes.bool.isRequired,
    table: PropTypes.object,
    dataPreview: PropTypes.object,
    enhancedAnalysis: PropTypes.object
  },

  mixins: [immutableMixin],


  render(){
    if (!this.props.tableExists || !this.isDataPreview()){
      return (
        <EmptyState>
          No Data.
        </EmptyState>
      );
    }
    const {table} = this.props;
    const columns = table.get('columns');

    const headerRow = this.renderHeaderRow();

    const columnsRows = columns.map((c) => {
      const values = this.getColumnValues(c);
      let result = values.filter((val) => val !== '').join(', ');
      return this.renderBodyRow(c, this.renderNameColumnCell(c), result);
    });

    return (
      <div>
        <Table responsive className="table table-striped">
          <thead>
            {headerRow}
          </thead>
          <tbody>
            {columnsRows}
          </tbody>
        </Table>
      </div>
    );
  },

  renderNameColumnCell(column){
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

  renderHeaderRow(){
    const simpleHeader = (
      <tr>
        <th>
          Column
        </th>
        <th>
          Sample Values
        </th>
      </tr>
    );

    if (!this.hasEnhancedAnalysis()){
      return simpleHeader;
    }

    const enhancedHeader = this.getEnahncedHeader().filter(h => !h.skip).map( (header) =>
      {
        return (<th>{header.label}</th>);
      }
    );

    return (
      <tr>
        <th>
          Column
        </th>
        <th>
          Sample Values
        </th>
        {enhancedHeader}
      </tr>
    );

  },

  getEnahncedHeader(){
    const dataHeader = this.props.enhancedAnalysis.get('data').first();
    const header = _.map(_.keys(enhancedColumnsDescription), (key) => {
      const h = enhancedColumnsDescription[key];
      return {
        name: key,
        label: h.name,
        desc: h.desc,
        idx: dataHeader.indexOf(key),
        formatFn: h.formatFn,
        skip: h.skip
      };

    }
    );
    return header;
    /* const header = this.props.enhancedAnalysis.get('data').first().map((h, idx) =>{
       return {
       name: h,
       idx: idx
       };
       }); */

  },


  renderBodyRow(columnName, columnNameCell, value){
    let enhancedCells = [];
    if ( this.hasEnhancedAnalysis()){
      const varNameIndex = this.props.enhancedAnalysis.get('data').first().indexOf('var_name');
      const header = this.getEnahncedHeader();
      const rows = this.props.enhancedAnalysis.get('data').rest();
      const rowToRender = rows.find((row) => {
        return row.get(varNameIndex) === columnName;
      });

      const rowValuesMap = header.map(h => {
        h.value = rowToRender.get(h.idx);
        return h;
      });

      enhancedCells = header.filter(h => !h.skip).map(h => {
        let cellValue = h.value;
        if (h.formatFn){
          cellValue = h.formatFn(cellValue, rowValuesMap);
        }
        return (<td>{cellValue}</td>);
      });

    }

    return (
      <tr>
        <td>
          {columnNameCell}
        </td>
        <td>
          {value}
        </td>
        {enhancedCells}
      </tr>
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
  },

  hasEnhancedAnalysis(){
    return this.props.enhancedAnalysis &&
    !_.isEmpty(this.props.enhancedAnalysis.toJS());
  }


});
