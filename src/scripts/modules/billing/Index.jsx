import React from 'react';
import {fromJS, List} from 'immutable';
import FileSize from '../../react/common/FileSize';
import ApplicationStore from '../../stores/ApplicationStore';
import MetricsApi from '../metrics/MetricsApi';

export default React.createClass({

  getInitialState: function() {
    return {
      metricsData: []
    };
  },

  componentDidMount: function() {
    MetricsApi
      .getProjectMetrics('2016-08-01', '2016-08-31', 'day')
      .then((response) => {
        this.setState({
          metricsData: fromJS(response)
        });
      });
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        <ul className="nav nav-tabs">
          <li role="presentation">
            <a href={this.projectPageUrl('settings-users')}>Users</a>
          </li>
          <li role="presentation">
            <a href={this.projectPageUrl('settings')}>Settings</a>
          </li>
          <li role="presentation">
            <a href={this.projectPageUrl('settings-limits')}>Limits</a>
          </li>
          <li role="presentation" className="active">
            <a href={this.projectPageUrl('settings-billing')}>Billing</a>
          </li>
        </ul>
        <table className="table">
          <thead>
          <tr>
            <th>Date</th>
            <th>Storage IO</th>
            <th>Application Credits</th>
          </tr>
          </thead>
          <tbody>
          {this.state.metricsData.map((item) => {
            return List([
              this.daySummary(item),
              item.get('components').map(this.dayComponents)
            ]);
          })}
          </tbody>
        </table>
      </div>
    );
  },

  daySummary(data) {
    return (
      <tr>
        <td><strong>{data.get('date')}</strong></td>
        <td>
          <strong>
            <FileSize size={this.dayComponentIoSummary(data.get('components'), 'storage')}/>
          </strong>
        </td>
        <td>
          <strong>N/A</strong>
        </td>
      </tr>
    );
  },

  dayComponents(component) {
    return (
      <tr>
        <td><span style={{paddingLeft: '10px'}}>{component.get('name')}</span></td>
        <td>
          <FileSize size={
            component.get('storage').get('inBytes') + component.get('storage').get('outBytes')
          }/>
        </td>
        <td>
          N/A
        </td>
      </tr>
    );
  },

  dayComponentIoSummary(data, metric) {
    return data
      .reduce(function(reduction, component) {
        return reduction
          + component.get(metric).get('inBytes')
          + component.get(metric).get('outBytes');
      }, 0);
  },

  projectPageUrl(path) {
    return ApplicationStore.getProjectPageUrl(path);
  }

});
