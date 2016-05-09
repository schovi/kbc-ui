import React, {PropTypes} from 'react';
// import {List} from 'immutable';
import StorageTableLink from '../../../components/react/components/StorageApiTableLinkEx';
import {Link} from 'react-router';

import SelectedProfilesList from './SelectedProfilesList';

const COMPONENT_ID = 'keboola.ex-google-analytics-v4';

export default React.createClass({
  propTypes: {
    queries: PropTypes.object.isRequired,
    allProfiles: PropTypes.object.isRequired,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired,
    configId: PropTypes.string.isRequired
  },

  render() {
    return (
      <div className="table table-striped table-hover">
        <div className="thead">
          <div className="tr">
            <div className="th">
              <strong>Name </strong>
            </div>
            <div className="th">
              <strong> Date Range(s) </strong>
            </div>
            <div className="th">
              <strong> Selected Profile(s) </strong>
            </div>
            <div className="th">
              {/* right arrow */}
            </div>
            <div className="th">
              <strong> Output Table </strong>
            </div>
            <div className="th">
              {/* action buttons */}
            </div>
          </div>
        </div>
        <div className="tbody">
          {this.props.queries.map((q) => this.renderQueryRow(q))}
        </div>
      </div>
    );
  },

  renderQueryRow(query) {
    const propValue = (propName) => query.getIn([].concat(propName));
    const queryProfiles = [propValue(['query', 'viewId'])];

    console.log(query.toJS());
    return (
      <Link
        to={COMPONENT_ID + '-query-detail'}
        params={{
          config: this.props.configId,
          queryId: query.get('id')
        }}
        className="tr">
        <div className="td">
          {propValue('name')}
        </div>
        <div className="td">
          {this.renderDateRanges(propValue(['query', 'dateRanges']))}
        </div>
        <div className="td">
          <SelectedProfilesList
            allProfiles={this.props.allProfiles}
            profileIds={queryProfiles} />
        </div>
        <div className="td">
          <i className="kbc-icon-arrow-right" />
        </div>
        <div className="td">
          <StorageTableLink tableId={propValue('outputTable')} />
        </div>
        <div className="td">
          {/* action buttons */}
        </div>
      </Link>
    );
  },

  renderDateRanges(ranges) {
    return (
      <span>
        <small>
          {ranges.map((r) =>
            <div>
              {r.get('startDate')} - {r.get('endDate')}
            </div>
           )}
        </small>
      </span>
    );
  }

});
