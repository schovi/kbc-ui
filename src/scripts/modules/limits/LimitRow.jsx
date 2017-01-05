import React, {PropTypes} from 'react';
import MetricGraph from './MetricGraph';
import {Button} from 'react-bootstrap';
import {bytesToGBFormatted, numericMetricFormatted} from '../../utils/numbers';
import EditLimitButton from './EditLimitButton';
import LimitProgress from './LimitProgress';
import classnames from 'classnames';
import contactSupport from '../../utils/contactSupport';
import SwitchButton from './SwitchButton';

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
    /* eslint-disable react/no-did-mount-set-state */
    this.setState({
      elWidth: React.findDOMNode(this.refs.limit).offsetWidth
    });
    /* eslint-enable react/no-did-mount-set-state */
  },

  render() {
    const {limit} = this.props;
    return (
      <div className="td kbc-limit" ref="limit">
        <div className={classnames('kbc-limit-inner', {
          'kbc-limit-alarm': limit.get('isAlarm') || limit.get('limitValue', 0) < limit.get('metricValue', 0)
        })}>
          <div style={{height: `${0.5 * this.state.elWidth}px`, position: 'relative'}}>
            {this.renderVizualization()}
          </div>
          <div>
          <h3>
            {limit.get('name')}
          </h3>
          </div>
          <div className="kbc-limit-values">
            <h4>{this.limit()}</h4>
          </div>
          <div className="kbc-limit-action">
            {this.renderActionButton()}
          </div>
        </div>
      </div>
    );
  },

  limit() {
    const {limit}  = this.props;
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
      return limit.get('limitValue') > 0 ? <strong>ENABLED</strong> : <strong>DISABLED</strong>;
    } else if (!limit.get('limitValue') && limit.get('limitValue') !== 0) {
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
    const {limit, canEdit} = this.props;
    if (limit.get('graph')) {
      return this.renderGraph();
    }
    if ((limit.get('limitValue') || limit.get('limitValue') === 0) && limit.get('metricValue')) {
      return this.renderProgress();
    }
    if (limit.get('unit') === 'flag') {
      return (
        <SwitchButton
          limit={limit}
          canEdit={canEdit}
          />
      );
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
  },

  renderActionButton() {
    const {limit} = this.props;

    if (!limit.get('limitValue') && limit.get('limitValue') !== 0) {
      return <span/>;
    }

    if (limit.get('unit') === 'flag') {
      return <span/>;
    }

    if (this.props.canEdit) {
      return (
        <EditLimitButton limit={this.props.limit}/>
      );
    }

    return (
      <Button bsStyle="success" onClick={contactSupport}>
        <span className="fa fa-plus"/> Request More
      </Button>
    );
  }

});
