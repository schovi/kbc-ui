import React from 'react';
import {fromJS, List, Map} from 'immutable';
import FileSize from '../../../react/common/FileSize';
import ApplicationStore from '../../../stores/ApplicationStore';
import MetricsApi from '../MetricsApi';
import moment from 'moment';
import Graph from './Graph';
import ComponentsStore from '../../components/stores/ComponentsStore';

function getDatesForLastMonth() {
  const dateTo = moment().subtract(1, 'day');
  const dateFrom = moment().subtract(1, 'day').subtract(1, 'month');

  return {
    dateFrom: dateFrom.format('YYYY-MM-DD'),
    dateTo: dateTo.format('YYYY-MM-DD')
  };
}

export default React.createClass({

  getInitialState: function() {
    return {
      metricsData: fromJS([]),
      dates: getDatesForLastMonth()
    };
  },

  componentDidMount: function() {
    this.loadMetricsData()
      .then((response) => {
        this.setState({
          metricsData: fromJS(response)
        });
      });
  },

  loadMetricsData: function() {
    return MetricsApi.getProjectMetrics(this.state.dates.dateFrom, this.state.dates.dateTo, 'day');
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
        <div className="kbc-header">
          <div className="row">
            <div className="col-md-6">
              <h3>
                {'Consumed storage capacity from '}
                {moment(this.state.dates.dateFrom).format('MMM D, YYYY')}
                {' to '}
                {moment(this.state.dates.dateTo).format('MMM D, YYYY')}
              </h3>
              <Graph
                data={this.state.metricsData.map((item) => {
                  return Map({
                    date: item.get('date'),
                    value: this.dayComponentIoSummary(item.get('components'), 'storage')
                  });
                })}
              />
            </div>
            <div className="col-md-6">
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
          </div>
        </div>

      </div>
    );
  },

  daySummary(data) {
    return (
      <tr>
        <td><strong>{moment(data.get('date')).format('MMM D, YYYY')}</strong></td>
        <td>
          <strong>
            <FileSize size={this.dayComponentIoSummary(data.get('components'), 'storage')}/>
          </strong>
        </td>
      </tr>
    );
  },

  getComponentNameAndIcon(componentSlug) {
    const componentFromStore = ComponentsStore.getComponent(componentSlug);
    return {
      name: componentFromStore ? componentFromStore.get('name') : componentSlug,
      icon: componentFromStore ? componentFromStore.get('ico32') : ''
    };
  },

  dayComponents(component) {
    const componentNameAndIcon = this.getComponentNameAndIcon(component.get('name'));
    return (
      <tr>
        <td>
          <img src={componentNameAndIcon.icon} />
          <span style={{paddingLeft: '10px'}}>{componentNameAndIcon.name}</span>
        </td>
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
