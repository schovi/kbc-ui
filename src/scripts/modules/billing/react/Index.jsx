import React from 'react';
import {fromJS, List} from 'immutable';
import FileSize from '../../../react/common/FileSize';
import ApplicationStore from '../../../stores/ApplicationStore';
import MetricsApi from '../MetricsApi';
import RoutesStore from '../../../stores/RoutesStore';
import YearMonthPagination from './YearMonthPagination';
import {formatAsYearMonth} from '../helpers';

function getDatesFromYearMonth(yearMonth) {
  const date = new Date(yearMonth.substr(0, 4), yearMonth.substr(5, 2), 0);
  const day = date.getDate();
  const fullDay = day >= 10 ? day : ('0' + day);

  return {
    dateFrom: formatAsYearMonth(date.getFullYear(), date.getMonth() + 1) + '-01',
    dateTo: formatAsYearMonth(date.getFullYear(), date.getMonth() + 1) + '-' + fullDay
  };
}

function getCurrentYearMonth() {
  const date = new Date();
  return formatAsYearMonth(date.getFullYear(), date.getMonth() + 1);
}

export default React.createClass({

  getInitialState: function() {
    return {
      metricsData: fromJS([]),
      month: RoutesStore.getCurrentRouteParam('month', getCurrentYearMonth())
    };
  },

  componentDidMount: function() {
    this.loadMetricsData(this.state.month)
      .then((response) => {
        this.setState({
          metricsData: fromJS(response)
        });
      });
  },

  componentWillReceiveProps: function() {
    const selectedYearMonth = RoutesStore.getCurrentRouteParam('month', getCurrentYearMonth());
    if (selectedYearMonth !== this.state.month) {
      this.setState({
        month: selectedYearMonth
      });
      this.loadMetricsData(selectedYearMonth)
        .then((response) => {
          this.setState({
            metricsData: fromJS(response)
          });
        }, () => {
          this.setState({
            metricsData: fromJS([])
          });
        });
    }
  },

  loadMetricsData: function(yearMonth) {
    const dates = getDatesFromYearMonth(yearMonth);
    return MetricsApi.getProjectMetrics(dates.dateFrom, dates.dateTo, 'day')
  },

  render() {
    const dates = getDatesFromYearMonth(this.state.month);
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
        <div className="kbc-header">
          <div className="row">
            <div className="col-sm-6">
              <h3>Showing billing data from {dates.dateFrom} to {dates.dateTo}</h3>
            </div>
            <div className="col-sm-6">
              <div className="pull-right">
                <YearMonthPagination
                  min="2016-08"
                  max={getCurrentYearMonth()}
                  current={this.state.month}
                />
              </div>
            </div>
          </div>
        </div>
        <table className="table">
          <thead>
          <tr>
            <th>Date</th>
            <th>Storage IO</th>
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
