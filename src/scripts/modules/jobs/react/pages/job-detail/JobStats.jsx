import React from 'react';
import {addons} from 'react/addons';
import {Loader} from 'kbc-react-components';
import {Map} from 'immutable';

import {filesize} from '../../../../../utils/utils';
import TablesList from './TablesList';
import FilesPie from './FilesPie';

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

function message(id, params) {
  return new IntlMessageFormat(MESSAGES[id]).format(params);
}

export default React.createClass({
  propTypes: {
    stats: React.PropTypes.object.isRequired,
    isLoading: React.PropTypes.bool.isRequired
  },
  mixins: [addons.PureRenderMixin],

  dataSize() {
    return filesize(this.props.stats.getIn(['files', 'total', 'dataSizeBytes', 'total']));
  },

  filesCount() {
    return this.props.stats.getIn(['files', 'total', 'count']);
  },

  loader() {
    return this.props.isLoading ? <Loader/> : '';
  },

  pieData() {
    return this.props.stats
      .getIn(['files', 'tags', 'tags'])
      .map((tag) => {
        return Map({
          Tag: tag.get('tag'),
          Size: tag.getIn(['dataSizeBytes', 'total'])
        });
      });
  },

  render() {
    return (
      <div className="clearfix">
        <div className="col-md-4">
          <h4>
            Imported Tables {this.importsTotal()} {this.loader()}
          </h4>
          <TablesList tables={this.props.stats.getIn(['tables', 'import'])}/>
        </div>
        <div className="col-md-4">
          <h4>
            Exported Tables {this.exportsTotal()}
          </h4>
          <TablesList tables={this.props.stats.getIn(['tables', 'export'])}/>
        </div>
        <div className="col-md-4">
          <h4>
            Data Transfer <small>{message('TOTAL_FILES', {totalCount: this.filesCount()})}</small>
          </h4>
          <div className="text-center">
            <h1>{this.dataSize()}</h1>
            {this.filesPie()}
          </div>
        </div>
      </div>
    );
  },

  filesPie() {
    const pieData = this.pieData();
    if (pieData.count() <= 1) {
      return null;
    } else {
      return (
        <FilesPie data={pieData}/>
      );
    }
  },

  importsTotal() {
    const total = this.props.stats.getIn(['tables', 'import', 'totalCount']);
    return total > 0 ? <small>{message('TOTAL_IMPORTS', {totalCount: total})}</small> : null;
  },

  exportsTotal() {
    const total = this.props.stats.getIn(['tables', 'export', 'totalCount']);
    return total > 0 ? <small>{message('TOTAL_EXPORTS', {totalCount: total})}</small> : null;
  }



});
