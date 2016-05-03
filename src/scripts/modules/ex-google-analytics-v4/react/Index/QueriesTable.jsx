import React, {PropTypes} from 'react';
import StorageTableLink from '../../../components/react/components/StorageApiTableLinkEx';

import ProfileInfo from '../ProfileInfo';

export default React.createClass({
  propTypes: {
    queries: PropTypes.object.isRequired,
    allProfiles: PropTypes.object.isRequired,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired
  },

  render() {
    return (
      <div className="table table-striped table-hover">
        <div className="thead">
          <div className="tr">
            <div className="th">
              <strong> Query Name </strong>
            </div>
            <div className="th">
              <strong> Date Range(s) </strong>
            </div>
            <div className="th">
              <strong> Profile(s) </strong>
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
    console.log(query.toJS());
    return (
      <div className="tr">
        <div className="td">
          {propValue('name')}
        </div>
        <div className="td">
          {this.renderDateRanges(propValue(['query', 'dateRanges']))}
        </div>
        <div className="td">
          <ProfileInfo
            allProfiles={this.props.allProfiles}
            selectedProfiles={propValue(['query', 'viewId'])} />
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
      </div>
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
