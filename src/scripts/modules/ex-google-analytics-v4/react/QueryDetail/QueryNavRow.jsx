import React, {PropTypes} from 'react';
import {Link} from 'react-router';

const COMPONENT_ID = 'keboola.ex-google-analytics-v4';

export default React.createClass({
  propTypes: {
    query: PropTypes.object.isRequired,
    configurationId: PropTypes.string.isRequired
  },

  render() {
    return (
      <Link
        className="list-group-item"
        to={`${COMPONENT_ID}-query-detail`}
        params={this.linkParams()}
        >
        <strong>{this.props.query.get('name')}</strong>
      </Link>
    );
  },

  linkParams() {
    return {
      config: this.props.configurationId,
      queryId: this.props.query.get('id')
    };
  }
});
