import React from 'react';
import {List, fromJS} from 'immutable';
import moment from 'moment';
import MetricsApi from '../MetricsApi';
import FileSize from '../../../react/common/FileSize';
import ComponentsStore from '../../components/stores/ComponentsStore';

function getDatesForLastYear() {
  const monthAgo = moment().subtract(1, 'month');
  const dateTo = moment([monthAgo.get('year'), monthAgo.get('month'), 31]);
  const dateFrom = monthAgo.subtract(12, 'month');

  return {
    dateFrom: dateFrom.format('YYYY-MM-01'),
    dateTo: dateTo.format('YYYY-MM-DD')
  };
}

export default React.createClass({

  getInitialState: function() {
    return {
      metricsData: fromJS([]),
      dates: getDatesForLastYear()
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
    return MetricsApi.getProjectMetrics(this.state.dates.dateFrom, this.state.dates.dateTo, 'month');
  },

  render() {
    return (
      <div>
        <h3>
          {'Consumed Storage IO from '}
          {moment(this.state.dates.dateFrom).format('MMM D, YYYY')}
          {' to '}
          {moment(this.state.dates.dateTo).format('MMM D, YYYY')}
        </h3>
        <table className="table">
          <thead>
          <tr>
            <th>Month</th>
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
        <td>
          <strong>{moment(data.get('dateFrom')).format('MMM D, YYYY')}</strong>
          {' - '}
          <strong>{moment(data.get('dateTo')).format('MMM D, YYYY')}</strong>
        </td>
        <td>
          <strong>
            <FileSize size={this.dayComponentIoSummary(data.get('components'), 'storage')}/>
          </strong>
        </td>
      </tr>
    );
  },

  renderComponentNameAndIcon(componentSlug) {
    const componentFromStore = ComponentsStore.getComponent(componentSlug);

    if (componentFromStore) {
      return (
        <div>
          <img src={componentFromStore.get('ico32')} />
          <span style={{paddingLeft: '10px'}}>{componentFromStore.get('name')}</span>
        </div>
      );
    } else if (componentSlug === 'transformation') {
      return (
        <div>
          <span style={{paddingLeft: '10px'}}>Transformations</span>
        </div>
      );
    } else if (componentSlug === 'storage-direct') {
      return (
        <div>
          <span style={{paddingLeft: '10px'}}>Storage Direct</span>
        </div>
      );
    } else {
      return (
        <div>
          <span style={{paddingLeft: '10px'}}>{componentSlug}</span>
        </div>
      );
    }
  },

  dayComponents(component) {
    return (
      <tr>
        <td>
          {this.renderComponentNameAndIcon(component.get('name'))}
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
  }

});
