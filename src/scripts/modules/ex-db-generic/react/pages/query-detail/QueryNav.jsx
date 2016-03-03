import React, {PropTypes} from 'react';
import SearchRow from '../../../../../react/common/SearchRow';
import NavRow from './QueryNavRow';
import actionsProvisioning from '../../../actionsProvisioning';

export default React.createClass({
  propTypes: {
    queries: PropTypes.object.isRequired,
    configurationId: PropTypes.string.isRequired,
    filter: PropTypes.string.isRequired,
    componentId: PropTypes.string.isRequired
  },
  render() {
    return (
      <div className="kbc-container">
        <SearchRow
          query={this.props.filter}
          onChange={this.handleFilterChange}
          />
        <div className="list-group">
          {this.rows()}
        </div>
      </div>
    );
  },

  rows() {
    if (this.props.queries.count()) {
      return this.props.queries.map((query) => {
        return React.createElement(NavRow, {
          query: query,
          configurationId: this.props.configurationId,
          componentId: this.props.componentId
        });
      });
    } else {
      return (
        <div className="list-group-item">
          No queries found.
        </div>
      );
    }
  },

  handleFilterChange(newQuery) {
    const actionCreators = actionsProvisioning.createActions(this.props.componentId);
    actionCreators.setQueriesFilter(this.props.configurationId, newQuery);
  }
});
