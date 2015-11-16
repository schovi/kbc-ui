import React, {PropTypes} from 'react';

import immutableMixin from '../../../../../react/mixins/ImmutableRendererMixin';
import EmptyState from '../../../../components/react/components/ComponentEmptyState';
import {Table} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    dataPreview: PropTypes.object
  },

  mixins: [immutableMixin],

  render() {
    const data = this.props.dataPreview;
    if (data.count() === 0) {
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
  }

});
