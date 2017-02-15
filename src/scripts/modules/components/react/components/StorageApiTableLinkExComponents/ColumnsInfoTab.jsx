import React, {PropTypes} from 'react';
import _ from 'underscore';

import EmptyState from '../../../../components/react/components/ComponentEmptyState';
import immutableMixin from '../../../../../react/mixins/ImmutableRendererMixin';

import Tooltip from '../../../../../react/common/Tooltip';
import enhancedColumnsTemplate from './EnhancedComlumnsTemplate';
import EnhancedAnalysisRunControl from './EnhancedAnalysisRunControl';
import {Table} from 'react-bootstrap';


export default React.createClass({
  propTypes: {
    tableExists: PropTypes.bool.isRequired,
    table: PropTypes.object,
    dataPreview: PropTypes.object,
    dataPreviewError: PropTypes.string,
    enhancedAnalysis: PropTypes.object,
    isRedshift: PropTypes.bool,
    onRunAnalysis: PropTypes.func,
    isCallingRunAnalysis: PropTypes.bool,
    loadingProfilerData: PropTypes.bool

  },

  mixins: [immutableMixin],

  render() {
    if (this.props.dataPreviewError) {
      return (
          <EmptyState>
            {this.props.dataPreviewError}
          </EmptyState>
      );
    }

    if (!this.props.tableExists || !this.isDataPreview()) {
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
          {headerRow}
          <tbody>
            {columnsRows}
          </tbody>
        </Table>
      </div>
    );
  },

  renderNameColumnCell(column) {
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

  renderHeaderRow() {
    const simpleHeader = (
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
    );

    if (!this.props.isRedshift) {
      return simpleHeader;
    }

    const enhancedHeader = this.getEnahncedHeader().filter(h => !h.skip).map((header) => {
      return (
        <th>
          {header.label}
          <Tooltip
            tooltip={header.desc}
            placement="top">
            <i className="fa fa-fw fa-question-circle" />
          </Tooltip>
        </th>
      );
    });

    return (
      <thead>
        <tr>
          <th />
          <th />
          <td colSpan="4">
            <EnhancedAnalysisRunControl
              enhancedAnalysis={this.props.enhancedAnalysis}
              table={this.props.table}
              onRunAnalysis={this.props.onRunAnalysis}
              isCallingRunAnalysis={this.props.isCallingRunAnalysis}
              loadingProfilerData={this.props.loadingProfilerData}
            />

          </td>
        </tr>
        <tr>
          <th>
            Column
          </th>
          <th>
            Sample Values
          </th>
          {enhancedHeader}
        </tr>
      </thead>
    );
  },

  getEnahncedHeader() {
    let dataHeader = null;
    if (this.hasEnhancedData()) {
      dataHeader = this.props.enhancedAnalysis.get('data').first();
    }
    return _.map(_.keys(enhancedColumnsTemplate), (key) => {
      const h = enhancedColumnsTemplate[key];
      return {
        name: key,
        label: h.name,
        desc: h.desc,
        idx: dataHeader ? dataHeader.indexOf(key) : 0,
        formatFn: h.formatFn,
        skip: h.skip
      };
    });
  },


  renderBodyRow(columnName, columnNameCell, value) {
    let enhancedCells = [];
    if (this.props.isRedshift) {
      if (this.hasEnhancedData()) {
        const varNameIndex = this.props.enhancedAnalysis.get('data').first().indexOf('var_name');
        const header = this.getEnahncedHeader();
        const rows = this.props.enhancedAnalysis.get('data').rest();
        const rowToRender = rows.find((row) => {
          return row.get(varNameIndex).toUpperCase() === columnName.toUpperCase();
        });
        if (!rowToRender) {
          return (
            <tr>
              <td>
                {columnNameCell}
              </td>
              <td>
                {value}
              </td>
            </tr>
          );
        }
        const rowValuesMap = header.map(h => {
          h.value = rowToRender.get(h.idx);
          return h;
        });

        enhancedCells = header.filter(h => !h.skip).map(h => {
          let cellValue = h.value;
          if (h.formatFn) {
            cellValue = h.formatFn(cellValue, rowValuesMap);
          }
          return (
            <td>
              {cellValue}
            </td>
          );
        });
      } else {
        const header = this.getEnahncedHeader();
        enhancedCells = header.filter(h => !h.skip).map(() => {
          return (
            <td>
              -
            </td>
          );
        });
      }
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

  getColumnValues(columnName) {
    const data = this.props.dataPreview;
    const columnIndex = data.first().indexOf(columnName);
    const result = data
    .shift()
    .map( (row) => {
      return row.get(columnIndex);
    });
    return result;
  },

  isDataPreview() {
    return !_.isEmpty(this.props.dataPreview.toJS());
  },

  hasEnhancedAnalysis() {
    return this.props.enhancedAnalysis &&
           !_.isEmpty(this.props.enhancedAnalysis.toJS());
  },

  hasEnhancedData() {
    return this.hasEnhancedAnalysis() && !_.isEmpty(this.props.enhancedAnalysis.toJS().data);
  }

});
