import React from 'react';
import Immutable from 'immutable';
import {addons} from 'react/addons';
import later from 'later';

import {getRunIdStats} from '../../../../components/StorageApi';
import JobStats from './JobStats';


export default React.createClass({
  propTypes: {
    runId: React.PropTypes.string.isRequired,
    autoRefresh: React.PropTypes.bool.isRequired,
    mode: React.PropTypes.string.isRequired
  },

  mixins: [addons.PureRenderMixin],

  componentDidMount() {
    this.collectStats(this.props.runId);
    if (this.props.autoRefresh) {
      this.startPolling();
    }
  },

  componentWillReceiveProps(nextProps) {
    if (!nextProps.autoRefresh) {
      /* jslint browser:true */
      setTimeout(this.stopPolling, 2000); // events can be delayed
      this.collectStats(nextProps.runId);
    }

    if (nextProps.runId !== this.props.runId) {
      this.setState({
        stats: null
      });
      this.collectStats(nextProps.runId);
    }
  },

  componentWillUnmount() {
    this.stopPolling();
  },

  startPolling() {
    const schedule = later.parse.recur().every(5).second();
    this.stopPolling();
    this.timeout = later.setInterval(() => this.collectStats(this.props.runId), schedule);
  },

  stopPolling() {
    if (this.timeout) {
      this.timeout.clear();
    }
  },

  collectStats(runId) {
    this.setState({
      isLoading: true
    });
    getRunIdStats(runId)
      .then(this.receiveStats);
  },

  receiveStats(stats) {
    if (this.isMounted()) {
      this.setState({
        stats: Immutable.fromJS(stats),
        isLoading: false
      });
    }
  },

  getInitialState() {
    return {
      stats: null,
      isLoading: false
    };
  },

  render() {
    if (this.state.stats) {
      return (
        <JobStats
          stats={this.state.stats}
          isLoading={this.state.isLoading}
          mode={this.props.mode}
          />
      );
    } else {
      return (
        <div>
          Loading ...
        </div>
      );
    }
  }
});
