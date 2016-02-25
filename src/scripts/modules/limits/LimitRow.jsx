import React, {PropTypes} from 'react';
import MetricGraph from './MetricGraph';
import AlarmIndicator from './AlarmIndicator';
import {Button} from 'react-bootstrap';
import {Check} from 'kbc-react-components';
import {bytesToGBFormatted, numericMetricFormatted} from '../../utils/numbers';
import EditLimitButton from './EditLimitButton';

export default React.createClass({
  propTypes: {
    limit: PropTypes.object.isRequired,
    isKeenReady: PropTypes.bool.isRequired,
    canEdit: PropTypes.bool.isRequired,
    keenClient: PropTypes.object.isRequired
  },

  render() {
    const {limit} = this.props;
    return (
      <div className="td">
        <div>
          {this.renderGraph()}
        </div>
        <div>
        <h3>
          {limit.get('name')} {limit.get('isAlarm') ? <AlarmIndicator isAlarm={true} /> : null}
        </h3>
        </div>
        <div className="kbc-limit-values">
          <h4>{this.limit()}</h4>
        </div>
        <div className="kbc-limit-action">
          {this.props.canEdit ?
            <EditLimitButton limit={limit}/> :
            <Button bsStyle="success">
              <span className="fa fa-plus"/>
              Add More
            </Button>
          }
        </div>
      </div>
    );
  },

  limit() {
    const {limit}  = this.props;
    console.log('limit', limit.toJS());
    if (limit.get('unit') === 'bytes') {
      return (
        <span>
          <strong>{bytesToGBFormatted(limit.get('metricValue'))} GB</strong>
          <span className="kbc-limit-values-minor"> of </span>
          <span>{bytesToGBFormatted(limit.get('limitValue'))} GB</span>
          <span className="kbc-limit-values-minor"> used</span>
        </span>
      );
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
      limitValue: this.props.limit.get('limitValue'),
      unit: this.props.limit.get('unit'),
      client: this.props.keenClient
    });
  }

});