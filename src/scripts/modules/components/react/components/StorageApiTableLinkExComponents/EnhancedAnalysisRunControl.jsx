import React, {PropTypes} from 'react';
//import _ from 'underscore';
import immutableMixin from '../../../../../react/mixins/ImmutableRendererMixin';

export default React.createClass({
  propTypes: {
    table: PropTypes.object,
    enhancedAnalysis: PropTypes.object,
    onRunAnalysis: PropTypes.func

  },

  mixins: [immutableMixin],

  render(){
    return (
      <span>
        Enhanced Analysis:
        {this.renderStatus()}
        {/* {this.renderRunButton()} */}
      </span>
    );
  },

  renderStatus(){
    let status = '';
    if (!this.props.enhancedAnalysis){
      status = 'No results yet';
    }
    else{
      const okJob = this.props.enhancedAnalysis.get('okJob');
      const runningJob = this.props.enhancedAnalysis.get('runningJob');
      if (!okJob && runningJob){
        status = 'Preparing results...';
      }
      else{
        if(okJob){
          const finished = okJob.get('endTime');
          const tableChange = this.props.table.get('lastChangeDate');
          if (finished < tableChange){
            status = 'Outdated!';
          }else{
            status = 'Up-to-date';
          }

        }

      }
    }
    return (<span> {status} </span>);
  }


});
