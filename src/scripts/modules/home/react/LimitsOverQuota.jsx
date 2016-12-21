import React, {PropTypes} from 'react';
import {Link} from 'react-router';
import {bytesToGBFormatted, numericMetricFormatted} from '../../../utils/numbers';

import './limits.less';

export default React.createClass({
  propTypes: {
    limits: PropTypes.object.isRequired
  },

  render() {
    const {limits} = this.props;

    if (!limits.size) {
      return null;
    }

    return (
      <div className="row kbc-header kbc-limits">
        <div className="alert alert-danger">
          <h3>
            <span className="fa fa-exclamation-triangle"/> Project is over quota!
          </h3>
          <ul>
            {limits.map(this.limit)}
          </ul>
          <p>
            <Link to="settings-limits">
              Limits Settings
            </Link>
          </p>
        </div>
      </div>
    );
  },

  limit(limit, index) {
    let values;

    if (limit.get('unit') === 'bytes') {
      values = `(${bytesToGBFormatted(limit.get('metricValue'))} GB of ${bytesToGBFormatted(limit.get('limitValue'))} GB)`;
    } else {
      values = `(${numericMetricFormatted(limit.get('metricValue'))} of ${numericMetricFormatted(limit.get('limitValue'))})`;
    }

    return (
      <li key={index}>
        <strong>{limit.get('section')} - {limit.get('name')}</strong> {values}
      </li>
    );
  }

});