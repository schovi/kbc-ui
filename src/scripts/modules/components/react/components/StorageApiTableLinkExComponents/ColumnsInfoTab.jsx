import React, {PropTypes} from 'react';
import _ from 'underscore';

import EmptyState from '../../../../components/react/components/ComponentEmptyState';
import immutableMixin from '../../../../../react/mixins/ImmutableRendererMixin';

import {Table} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    tableExists: PropTypes.bool.isRequired,
    table: PropTypes.object,
    dataPreview: PropTypes.object
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
