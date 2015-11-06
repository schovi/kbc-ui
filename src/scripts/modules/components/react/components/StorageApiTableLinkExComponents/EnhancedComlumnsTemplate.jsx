import React from 'react';
import Tooltip from '../../../../../react/common/Tooltip';
import _ from 'underscore';

function renderLabel(caption) {
  return (<span className="label label-info">{caption}</span>);
}

export default {
  'data_type': {
    name: 'Data Type',
    formatFn: (value, rowValues) => {
      const format = _.find(rowValues, r => r.name === 'format').value;
      const ists = _.find(rowValues, r => r.name === 'is_ts').value;
      const result = format ? `${value} (${format})` : `${value}`;
      const tsTooltip = 'Can be interpreted as a time series.';
      const tsRender = (<small>{renderLabel('Timeseries')}</small>);

      if (ists === '1') {
        return (<span><div>{result}</div><Tooltip tooltip={tsTooltip} placement="top">
        {tsRender}</Tooltip></span>);
      } else {
        return result;
      }
    },
    desc: (<span>The type of data present in the column.  Possible values are:
      <div>String - alphanumeric characters</div>
      <div>Integer - whole numbers without decimals</div>
      <div>float - numbers with decimals</div>
      <div>bool - logical (true/false, 0/1)</div>
      <div>date or datetime</div></span>)
  },

  // merged to data_type
  'format': {
    name: 'Format',
    skip: true
  },

  // merged to data_type
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
      if (isid === 'no') {
        return val;
      } else {
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
    name: 'Change Direction',
    desc: 'Possible values: increasing, decreasing, variable.  For numeric values and dates, if the values are neither increasing or decreasing, they will be variable.  String columns will be blank.'
  }

};
