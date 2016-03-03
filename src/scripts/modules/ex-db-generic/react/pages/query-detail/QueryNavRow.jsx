import React, {PropTypes} from 'react';
import {Link} from 'react-router';

export default React.createClass({
  propTypes: {
    query: PropTypes.object.isRequired,
    configurationId: PropTypes.string.isRequired,
    componentId: PropTypes.string.isRequired
  },
  render() {
    return (
      <Link
        className="list-group-item"
        to={`ex-db-generic-${this.props.componentId}-query`}
        params={this.linkParams()}
        >
        <strong>{this.props.query.get('name')}</strong>
      </Link>
    );
  },

  linkParams() {
    return {
      config: this.props.configurationId,
      query: this.props.query.get('id')
    };
  }
});
