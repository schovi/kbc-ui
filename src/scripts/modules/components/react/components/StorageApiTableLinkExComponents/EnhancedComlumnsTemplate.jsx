import React from 'react';
import EnhancedAnalysisDataType from './EnhancedAnalysis/DataType';
import EnhancedAnalysisUniqueness from './EnhancedAnalysis/Uniqueness';

export default {
  'data_type': EnhancedAnalysisDataType,

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

  'val_ratio': EnhancedAnalysisUniqueness,

  'is_identity': {
    name: 'Identifying Column',
    desc: 'Can the values of this column be used as an identifier for each row?',
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
