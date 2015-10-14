import React, {PropTypes} from 'react';
import _ from 'underscore';

import EmptyState from '../../../../components/react/components/ComponentEmptyState';
import immutableMixin from '../../../../../react/mixins/ImmutableRendererMixin';

import Tooltip from '../../../../../react/common/Tooltip';
import {Table} from 'react-bootstrap';

function renderLabel(caption){
  return (<span className="label label-info">{caption}</span>);

}

const enhancedColumnsDescription = {
  'data_type': {
    name: 'Data Type',
    formatFn: (value, rowValues) => {
      const format = _.find(rowValues, r => r.name === 'format').value;
      const ists = _.find(rowValues, r => r.name === 'is_ts').value;
      const result = format ? `${value} (${format})` : `${value}`;
      const tsTooltip = 'Can be interpreted as a time series.';
      const tsRender = (<small>{renderLabel('Timeseries')}</small>);

      if (ists === '1'){
        return (<span><div>{result}</div><Tooltip tooltip={tsTooltip} placement='top'>
        {tsRender}</Tooltip></span>);
      }else{
        return result;
      }
    },
    desc: (<span>The type of data present in the column.  Possible values are:
      <div>String - alphanumeric characters</div>
      <div>Integer - whole numbers without decimals</div>
      <div>float - numbers with decimals</div>
      <div>and date or datetime</div></span>)

  },

  // merged to data_type
  'format': {
    name: 'Format',
    skip: true


  },

  //merged to data_type
  'is_ts': {
    name: 'Is ts',
    skip: true

  },

  'val_ratio': {
    name: 'Uniqueness(%)',
    desc: `If every value in the column is distinct, the uniqueness will be 100%.
Columns that have few distinct values repeatedly (such as categories) will have lower uniqueness value. If every row contains the same value, the uniqueness will be 0%.`,
    formatFn: (value, rowValues) => {
      const isid = _.find(rowValues, r => r.name === 'is_identity').value;
      const val = ((parseFloat(value)) * 100).toFixed(4);
      if (isid === 'no'){
        return val;
      }
      else{
        const idLabel = isid === 'yes' ? 'id' : 'id?';
        const tooltip = isid === 'yes' ? 'Identifying the table row' : 'Probably identifying the table row';
        return (
          <span>
            <div>{val}</div>
            <Tooltip tooltip={tooltip} placement="top">
              {renderLabel(idLabel)}
            </Tooltip>
          </span>
        );
      }


    }

  },

  'is_identity': {
    name: 'Identifying Column',
    desc: `Can the values of this column be used as an identifier for each row?`,
    skip: true

  },

  'mode': {
    name: 'Mode',
    desc: (<span>
            <div>Continuous - Highly distinctive values (Time series are continuous)</div>
            <div>Categories - Many rows contain the same values and there are finite possibilities.</div>
            <div>Useless - Almost all rows contain fewer than 2 distinct values</div></span>)

  },

  'monotonic': {
    name: 'Unchanging',
    desc: 'The values do not increase or decrease'

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
        return (
          <th>
            {header.label}
            <Tooltip
               tooltip={header.desc}
               placement="top">
              <i className="fa fa-fw fa-question-circle"></i>
            </Tooltip>
          </th>
        );
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
        return (
          <td>
            {cellValue}
          </td>
        );
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
