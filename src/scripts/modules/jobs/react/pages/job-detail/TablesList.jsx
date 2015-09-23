import React from 'react';

import duration from '../../../../../utils/duration';
import TableLinkEx from '../../../../components/react/components/StorageApiTableLinkEx';

export default React.createClass({
  propTypes: {
    tables: React.PropTypes.object.isRequired
  },

  duration(durationSeconds) {
    return duration(Math.round(durationSeconds));
  },

  rows() {
    const limit = 10;
    let rows = this.props.tables
      .get('tables')
      .toSeq()
      .slice(0, limit)
      .map((table) => {
        return (
          <li key={table.get('id')}>
            <TableLinkEx tableId={table.get('id')}>
              {table.get('id')} <span className="text-muted">{this.duration(table.get('durationTotalSeconds'))}</span>
            </TableLinkEx>
          </li>
        );
      })
      .toArray();

    const tablesCount = this.props.tables.get('tables').count();
    if (tablesCount > limit) {
      const message = tablesCount === 100 ? `More than ${tablesCount - limit} others.` : `${tablesCount - limit} others`;
      rows.push(
        <li key="more"><span>{message}</span></li>
      );
    }

    return rows;
  },

  render() {
    const rows = this.rows();
    if (rows.length) {
      return (
        <ul>{this.rows()}</ul>
      );
    } else {
      return (
        <div className="text-muted">No tables.</div>
      );
    }
  }
});
