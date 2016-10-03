import React from 'react';
import {addons} from 'react/addons';
import {Loader} from 'kbc-react-components';

import TablesList from './TablesList';
import JobMetrics from './JobMetrics';
import IntlMessageFormat from 'intl-messageformat';

const MESSAGES = {
  TOTAL_IMPORTS: '{totalCount, plural, ' +
    '=1 {one import total}' +
    'other {# imports total}}',
  TOTAL_EXPORTS: '{totalCount, plural, ' +
    '=1 {one export total}' +
    'other {# exports total}}',
  TOTAL_FILES: '{totalCount, plural, ' +
    '=1 {one files total}' +
    'other {# files total}}'
};

const MODE_TRANSFORMATION = 'transformation';
const MODE_DEFAULT = 'default';

function message(id, params) {
  return new IntlMessageFormat(MESSAGES[id]).format(params);
}

export default React.createClass({
  propTypes: {
    stats: React.PropTypes.object.isRequired,
    isLoading: React.PropTypes.bool.isRequired,
    mode: React.PropTypes.oneOf([MODE_DEFAULT, MODE_TRANSFORMATION]),
    jobMetrics: React.PropTypes.object.isRequired
  },
  mixins: [addons.PureRenderMixin],

  loader() {
    return this.props.isLoading ? <Loader/> : '';
  },

  render() {
    const isTransformation = this.props.mode === MODE_TRANSFORMATION;
    return (
      <div className="clearfix">
        <div className="col-md-4">
          <h4>
            {isTransformation ? 'Input' : 'Imported Tables'} {this.importsTotal()} {this.loader()}
          </h4>
          <TablesList tables={this.props.stats.getIn(['tables', isTransformation ? 'export' : 'import'])}/>
        </div>
        <div className="col-md-4">
          <h4>
            {isTransformation ? 'Output' : 'Exported Tables'} {this.exportsTotal()}
          </h4>
          <TablesList tables={this.props.stats.getIn(['tables', isTransformation ? 'import' : 'export'])}/>
        </div>
        <div className="col-md-4">
          <JobMetrics metrics={this.props.jobMetrics} />
        </div>
      </div>
    );
  },

  importsTotal() {
    if (this.props.mode === MODE_TRANSFORMATION) {
      return null;
    }
    const total = this.props.stats.getIn(['tables', 'import', 'totalCount']);
    return total > 0 ? <small>{message('TOTAL_IMPORTS', {totalCount: total})}</small> : null;
  },

  exportsTotal() {
    if (this.props.mode === MODE_TRANSFORMATION) {
      return null;
    }
    const total = this.props.stats.getIn(['tables', 'export', 'totalCount']);
    return total > 0 ? <small>{message('TOTAL_EXPORTS', {totalCount: total})}</small> : null;
  }

});
