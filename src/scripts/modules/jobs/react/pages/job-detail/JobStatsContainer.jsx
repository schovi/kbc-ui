import React from 'react';
import Immutable from 'immutable';
import {addons} from 'react/addons';
import later from 'later';

import {getRunIdStats} from '../../../../components/StorageApi';
import JobStats from './JobStats';

export default React.createClass({
    propTypes: {
        runId: React.PropTypes.string.isRequired,
        autoRefresh: React.PropTypes.bool.isRequired
    },

    mixins: [addons.PureRenderMixin],

    componentDidMount() {
        this.collectStats();
        if (this.props.autoRefresh) {
            this.startPolling();
        }
    },

    componentWillReceiveProps(nextProps) {
        if (!nextProps.autoRefresh) {
            this.stopPolling();
        }
    },

    componentWillUnmount() {
        this.stopPolling();
    },

    startPolling() {
        const schedule = later.parse.recur().every(5).second();
        this.stopPolling();
        this.timeout = later.setInterval(this.collectStats, schedule);
    },

    stopPolling() {
        if (this.timeout) {
            this.timeout.clear();
        }
    },

    collectStats() {
        this.setState({
           isLoading: true
        });
        getRunIdStats(this.props.runId)
            .then(function (stats) {
                this.setState({
                    stats: Immutable.fromJS(stats),
                    isLoading: false
                });
            }.bind(this));
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
                <JobStats stats={this.state.stats} isLoading={this.state.isLoading} />
            );
        } else {
            return (
              <div className="row">Loading ...</div>
            );
        }
    }
});
