import React, {PropTypes} from 'react';
import MetricGraph from './MetricGraph';
import AlarmIndicator from './AlarmIndicator';
import {Check} from 'kbc-react-components';
import classnames from 'classnames';
import numeral from 'numeral';


function bytesToGBFormatted(bytes) {
  const gb = bytes / (1000 * 1000 * 1000);
  return numeral(gb).format('0.00');
}

function numericMetricFormatted(value) {
  return numeral(value).format('0,00');
}

export default React.createClass({
  propTypes: {
    limit: PropTypes.object.isRequired,
    isKeenReady: PropTypes.bool.isRequired,
    keenClient: PropTypes.object.isRequired
  },

  render() {
    const {limit} = this.props;
    return (
      <div className={classnames('tr', {'danger': limit.get('isAlarm')})}>
        <span className="td">
          {
            limit.get('limitValue') ? <AlarmIndicator isAlarm={limit.get('isAlarm')} /> : null
          }
        </span>
        <span className="td">
          <h3>{limit.get('name')}</h3>
        </span>
        <span className="td">
          {this.limit()}
        </span>
        <span className="td" style={{width: '50%'}}>
          {this.renderGraph()}
        </span>
      </div>
    );
  },

  limit() {
    const {limit}  = this.props;
    if (limit.get('unit') === 'bytes') {
      return `${bytesToGBFormatted(limit.get('metricValue'))} GB of ${bytesToGBFormatted(limit.get('limitValue'))} GB used`;
    } else if (limit.get('unit') === 'flag') {
      return (
        <Check isChecked={!!limit.get('metricValue')} />
      );
    } else if (!limit.get('limitValue')) {
      return numericMetricFormatted(limit.get('metricValue'));
    } else {
      return `${numericMetricFormatted(limit.get('metricValue'))} / ${numericMetricFormatted(limit.get('limitValue'))}`;
    }
  },

  renderGraph() {
    const graph = this.props.limit.get('graph');
    if (!graph) {
      return null;
    }
    if (!this.props.isKeenReady) {
      return (
        <span>Loading ... </span>
      );
    }
    return React.createElement(MetricGraph, {
      query: {
        eventCollection: graph.get('eventCollection'),
        targetProperty: graph.get('targetProperty'),
        timeframe: 'this_30_days',
        interval: 'daily'
      },
      isAlarm: this.props.limit.get('isAlarm'),
      client: this.props.keenClient
    });
  }

});