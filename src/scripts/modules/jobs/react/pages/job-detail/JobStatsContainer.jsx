import React from 'react';
import Immutable from 'immutable';

import {getRunIdStats} from '../../../../components/StorageApi';
import JobStats from './JobStats';

export default React.createClass({
    propTypes: {
        runId: React.PropTypes.string.isRequired
    },

    componentDidMount() {
        getRunIdStats(this.props.runId)
            .then(function (stats) {
                this.setState({
                    stats: Immutable.fromJS(stats)
                });
            }.bind(this));
    },

    getInitialState() {
        return {
            stats: null
        }
    },

    render() {
        if (this.state.stats) {
            return (
                <JobStats stats={this.state.stats}></JobStats>
            );
        } else {
            return (
              <div className="row">Loading ...</div>
            );
        }
    }
});
