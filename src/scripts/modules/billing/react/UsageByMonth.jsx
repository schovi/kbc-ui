import React from 'react';
import {fromJS, List} from 'immutable';
import moment from 'moment';
import MetricsApi from '../MetricsApi';
import FileSize from '../../../react/common/FileSize';
import ComponentsStore from '../../components/stores/ComponentsStore';
import {Panel} from 'react-bootstrap';
import ComponentName from './../../../react/common/ComponentName';
import ComponentIcon from './../../../react/common/ComponentIcon';

function getDatesForMonthlyUsage() {
  return {
    dateFrom: '2016-08-17',
    dateTo: moment().subtract(1, 'day').format('YYYY-MM-DD')
  };
}

export default React.createClass({

  getInitialState: function() {
    return {
      metricsData: fromJS([]),
      dates: getDatesForMonthlyUsage()
    };
  },

  componentDidMount: function() {
    this.loadMetricsData()
      .then((response) => {
        this.setState({
          metricsData: fromJS(response).reverse()
        });
      });
  },

  loadMetricsData: function() {
    return MetricsApi.getProjectMetrics(this.state.dates.dateFrom, this.state.dates.dateTo, 'month');
  },

  render() {
    return (
      <div style={{marginBottom: '10em'}}>
        <h3>
          {'Consumed Storage IO from '}
          {moment(this.state.dates.dateFrom).format('MMM D, YYYY')}
          {' to '}
          {moment(this.state.dates.dateTo).format('MMM D, YYYY')}
        </h3>
        {this.state.metricsData.map((item) => {
          if (!item.get('components').isEmpty()) {
            return (
              <Panel collapsible={true} header={this.daySummary(item)} key={item.get('dateFrom') + '-' + item.get('dateTo')}>
                <table className="table table-striped">
                  {List([item.get('components').map(this.dayComponents)])}
                </table>
              </Panel>
            );
          } else {
            return (
              <Panel collapsible={true} header={this.daySummary(item)} key={item.get('dateFrom') + '-' + item.get('dateTo')}>
                N/A
              </Panel>
            );
          }
        })}
      </div>
    );
  },

  daySummary(data) {
    return (
      <div className="row" style={{paddingBottom: '1em'}}>
        <div className="col-sm-8">
          <strong>{moment(data.get('dateFrom')).format('MMM D, YYYY')}</strong>
          {' - '}
          <strong>{moment(data.get('dateTo')).format('MMM D, YYYY')}</strong>
        </div>
        <div className="col-sm-4">
          <strong>
            <FileSize size={this.dayComponentIoSummary(data.get('components'), 'storage')}/>
          </strong>
        </div>
      </div>
    );
  },

  renderComponentNameAndIcon(componentSlug) {
    const componentFromStore = ComponentsStore.getComponent(componentSlug);

    if (componentFromStore) {
      return (
        <span>
          <ComponentIcon component={componentFromStore} />
          <ComponentName component={componentFromStore} />
        </span>
      );
    } else if (componentSlug === 'storage-direct') {
      return (
        <span>
          <span className="kb-sapi-component-icon kbc-icon-storage" style={{fontSize: '32px', verticalAlign: 'middle'}}/>
          <span>Direct Storage API access</span>
        </span>
      );
    } else {
      return (
        <span>
          <span>{componentSlug}</span>
        </span>
      );
    }
  },

  dayComponents(component) {
    return (
      <tr>
        <td>
          <div className="row">
            <div className="col-md-8">
              {this.renderComponentNameAndIcon(component.get('name'))}
            </div>
            <div className="col-md-4">
              <span style={{lineHeight: '2em'}}>
                <FileSize size={
                  component.get('storage').get('inBytes') + component.get('storage').get('outBytes')
                }/>
              </span>
            </div>
          </div>
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
