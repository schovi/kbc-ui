import React from 'react';
import Tooltip from '../../../../../../react/common/Tooltip';
import Label from './Label';
import _ from 'underscore';

export default {
  name: 'Uniqueness(%)',
  desc: `If every value in the column is distinct, the uniqueness will be 100%.
Columns that have few distinct values repeatedly (such as categories) will have lower uniqueness value. If every row contains the same value, the uniqueness will be 0%.`,
  formatFn: (value, rowValues) => {
    const isid = _.find(rowValues, r => r.name === 'is_identity').value;
    const val = ((parseFloat(value)) * 100).toFixed(4);
    if (isid === 'no') {
      return val;
    } else {
      const idLabel = isid === 'yes' ? 'id' : 'id?';
      const tooltip = isid === 'yes' ? 'Identifying the table row' : 'Probably identifying the table row';
      return (
        <span>
            <div>{val}</div>
            <Tooltip tooltip={tooltip} placement="top">
              <Label caption={idLabel} />
            </Tooltip>
          </span>
      );
    }
  }
};
