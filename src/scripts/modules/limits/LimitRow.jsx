import React, {PropTypes} from 'react';
import MetricGraph from './MetricGraph';
import AlarmIndicator from './AlarmIndicator';
import {Button} from 'react-bootstrap';
import {Check} from 'kbc-react-components';
import {bytesToGBFormatted, numericMetricFormatted} from '../../utils/numbers';
import EditLimitButton from './EditLimitButton';
import LimitProgress from './LimitProgress';
import _ from 'underscore';

export default React.createClass({
  propTypes: {
    limit: PropTypes.object.isRequired,
    isKeenReady: PropTypes.bool.isRequired,
    canEdit: PropTypes.bool.isRequired,
    keenClient: PropTypes.object.isRequired
  },

  getInitialState() {
    return {
      elWidth: null
    };
  },

  componentDidMount() {
    _.defer(() => this.setState({
      elWidth: React.findDOMNode(this.refs.limit).offsetWidth
    }));
  },

  render() {
    console.log('limit', this.state);
    const {limit} = this.props;
    return (
      <div className="td kbc-limit" ref="limit">
        <div style={{height: `${0.5 * this.state.elWidth}px`, position: 'relative'}}>
          {this.renderVizualization()}
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
      return (
        <strong>{numericMetricFormatted(limit.get('metricValue'), limit.get('unit'))}</strong>
      );
    } else {
      return (
        <span>
          <strong>{numericMetricFormatted(limit.get('metricValue'), limit.get('unit'))}</strong>
          <span className="kbc-limit-values-minor"> of </span>
          <span>{numericMetricFormatted(limit.get('limitValue'), limit.get('unit'))}</span>
        </span>
      );
    }
  },

  renderVizualization() {
    const {limit} = this.props;
    if (limit.get('graph')) {
      return this.renderGraph();
    }
    if (limit.get('limitValue') && limit.get('metricValue')) {
      return this.renderProgress();
    }
    return null;
  },

  renderProgress() {
    const {limit} = this.props;
    return React.createElement(LimitProgress, {
      valueMax: limit.get('limitValue'),
      valueCurrent: limit.get('metricValue')
    });
  },

  renderGraph() {
    const graph = this.props.limit.get('graph');
    if (!this.props.isKeenReady) {
      return null;
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