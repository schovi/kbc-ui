import React from 'react';
import Tooltip from '../../../../../../react/common/Tooltip';
import _ from 'underscore';
import Label from './Label';

export default {
  name: 'Data Type',
  formatFn: (value, rowValues) => {
    const format = _.find(rowValues, r => r.name === 'format').value;
    const ists = _.find(rowValues, r => r.name === 'is_ts').value;
    const result = format ? `${value} (${format})` : `${value}`;
    const tsTooltip = 'Can be interpreted as a time series.';
    const tsRender = (
      <small>
        <Label caption="Timeseries" />
      </small>
    );

    if (ists === '1') {
      return (<span><div>{result}</div><Tooltip tooltip={tsTooltip} placement="top">
        {tsRender}</Tooltip></span>);
    } else {
      return result;
    }
  },
  desc: (
    <span>
      The type of data present in the column.  Possible values are:
      <div>String - alphanumeric characters</div>
      <div>Integer - whole numbers without decimals</div>
      <div>float - numbers with decimals</div>
      <div>bool - logical (true/false, 0/1)</div>
      <div>date or datetime</div>
    </span>
  )
};
