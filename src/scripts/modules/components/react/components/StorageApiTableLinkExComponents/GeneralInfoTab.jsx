import React, {PropTypes} from 'react';

import date from '../../../../../utils/date';
import moment from 'moment';
import _ from 'underscore';
import {Table} from 'react-bootstrap';
import immutableMixin from '../../../../../react/mixins/ImmutableRendererMixin';
import EmptyState from '../../../../components/react/components/ComponentEmptyState';
import filesize from 'filesize';

export default React.createClass({

  propTypes: {
    isLoading: PropTypes.bool,
    table: PropTypes.object,
    tableExists: PropTypes.bool.isRequired
  },

  mixins: [immutableMixin],

  render() {
    if (!this.props.tableExists) {
      let msg = 'Table does not exist yet.';
      if (this.props.isLoading) {
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
    const backend = table.getIn(['bucket', 'backend']);
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
            {this.renderTableRow('Storage', (<span className="label label-info">{backend}</span>))}
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

  renderTimefromNow(value) {
    const fromNow = moment(value).fromNow();
    return (
      <span> {date.format(value)}
        <small> {fromNow} </small>
      </span>
    );
  },

  renderTableRow(name, value) {
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
  }

});
