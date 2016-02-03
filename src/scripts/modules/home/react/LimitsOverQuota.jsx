import React, {PropTypes} from 'react';
import {Link} from 'react-router';

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
      <div className="row kbc-header">
        <div className="alert alert-danger">
          <h4>
            <span className="fa fa-exclamation-triangle"/> Project is over quota!
          </h4>
          <ul>
            {limits.map(this.limit)}
          </ul>
          <p>
            <Link to="settings-limits">
              Limits settings
            </Link>
          </p>
        </div>
      </div>
    );
  },

  limit(limit) {
    return (
      <li>
        <strong>{limit.get('name')}</strong> ({limit.get('metricValue')} of {limit.get('limitValue')})
      </li>
    );
  }
});