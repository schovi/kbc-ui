import React, {PropTypes} from 'react';
import immutableMixin from '../../../../../react/mixins/ImmutableRendererMixin';
import {Loader} from 'kbc-react-components';
import {Button} from 'react-bootstrap';
import {Link} from 'react-router';

export default React.createClass({
  propTypes: {
    table: PropTypes.object,
    enhancedAnalysis: PropTypes.object,
    onRunAnalysis: PropTypes.func,
    isCallingRunAnalysis: PropTypes.bool,
    loadingProfilerData: PropTypes.bool
  },

  mixins: [immutableMixin],

  render() {
    let profilerInfo = (<span><Loader /></span>);
    if (!this.props.loadingProfilerData) {
      profilerInfo = [
        (<span style={{'padding': 0}} className="col-xs-3">
            { this.renderResultsStatus()}
        </span>)
        ,
        (<span style={{'padding': 0}} className="col-xs-4">
        {this.renderRunStatus()}
         </span>)
      ];
    }
    return (
      <span className="col-xs-12" style={{'padding': 0}}>
        <span style={{'padding': 0}}
              className="col-xs-5">
          Enhanced Analysis:
        </span>
        {profilerInfo}
      </span>
    );
  },

  renderResultsStatus() {
    let status = 'No results';
    const enhancedAnalysis = this.props.enhancedAnalysis;
    const okJob = enhancedAnalysis ? enhancedAnalysis.get('okJob') : null;
    if (okJob) {
      const finished = okJob.get('endTime');
      const tableChange = this.props.table.get('lastChangeDate');
      if (finished < tableChange) {
        status = (<span className="label label-warning">Outdated</span>);
      } else {
        status = (<span className="label label-success">Up-to-date</span>);
      }
    }
    return (<span>{status}</span>);
  },

  renderRunStatus() {
    const enhancedAnalysis = this.props.enhancedAnalysis;
    const runningJob = enhancedAnalysis ? enhancedAnalysis.get('runningJob') : null;
    if (runningJob) {
      return (
        <span> <Loader />{' '}
          <Link to="jobDetail"
                params={{jobId: runningJob.get('id')}}>
            Analyzing...
          </Link>
        </span>
      );
    } else if (this.isShowRunButton()) {
      if (this.props.isCallingRunAnalysis) {
        return (<Loader />);
      } else {
        return (
          <Button style={{padding: 0}}
                  className="btn btn-link"
                  onClick={this.props.onRunAnalysis}>
            Run Analysis
          </Button>
        );
      }
    } else {
      return null;
    }
  },

  // Show if there are no results yet or analysis is outdated
  isShowRunButton() {
    const enhancedAnalysis = this.props.enhancedAnalysis;
    const okJob = enhancedAnalysis ? enhancedAnalysis.get('okJob') : null;
    if (!okJob) {
      return true;
    }
    const finished = okJob.get('endTime');
    const tableChange = this.props.table.get('lastChangeDate');
    if (finished < tableChange) {
      return true;
    } else {
      return false;
    }
  }

});
