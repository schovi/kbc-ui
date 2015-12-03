import React from 'react';
import ApplicationStore from '../../stores/ApplicationStore';
import createStoreMixin from '../../react/mixins/createStoreMixin';

export default React.createClass({
  mixins: [createStoreMixin(ApplicationStore)],

  getStateFromStores() {
    return {
      limits: ApplicationStore.getSapiToken().getIn(['owner', 'limits']),
      metrics: ApplicationStore.getSapiToken().getIn(['owner', 'metrics'])
    };
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        <div className="kbc-header">
          <div className="kbc-title">
            <h2>Limits</h2>
          </div>
        </div>
        <table className="table table-striped">
          <tbody>
            {this.state.limits.map(this.tableRow)}
          </tbody>
        </table>
        <div className="kbc-header">
          <div className="kbc-title">
            <h2>Metrics</h2>
          </div>
        </div>
        <table className="table table-striped">
          <tbody>
          {this.state.metrics.map(this.tableRow)}
          </tbody>
        </table>
      </div>
    );
  },

  tableRow(limit) {
    return (
      <tr>
        <td>{limit.get('name')}</td>
        <td>{limit.get('value')}</td>
      </tr>
    );
  }
});