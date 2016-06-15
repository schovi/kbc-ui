import React, {PropTypes} from 'react';

import immutableMixin from '../../../../../react/mixins/ImmutableRendererMixin';
import EmptyState from '../../../../components/react/components/ComponentEmptyState';
import {Table} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    dataPreview: PropTypes.object,
    dataPreviewError: PropTypes.string
  },

  mixins: [immutableMixin],

  render() {
    const {dataPreview, dataPreviewError} = this.props;

    if (dataPreviewError) {
      return (
        <EmptyState>
          {dataPreviewError}
        </EmptyState>
      );
    }

    if (dataPreview.count() === 0) {
      return (
        <EmptyState>
          No Data.
        </EmptyState>
      );
    }

    const header = dataPreview.first().map( (c) => {
      return (
        <th>
          {c}
        </th>
      );
    }).toArray();
    const rows = dataPreview.rest().map( (row) => {
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
