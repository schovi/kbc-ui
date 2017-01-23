import React, {PropTypes} from 'react';
import * as common from '../../common';
// import {List} from 'immutable';
// import StorageTableLink from '../../../components/react/components/StorageApiTableLinkEx';

import ActivateDeactivateButton from '../../../../react/common/ActivateDeactivateButton';
import RunExtractionButton from '../../../components/react/components/RunComponentButton';

import Tooltip from '../../../../react/common/Tooltip';
import {Loader} from 'kbc-react-components';
import Confirm from '../../../../react/common/Confirm';

// import {Link} from 'react-router';

const COMPONENT_ID = 'keboola.ex-google-drive';

function getDocumentTitle(query) {
  return common.queryFullName(query, ' / ');
}


export default React.createClass({
  propTypes: {
    queries: PropTypes.object.isRequired,
    configId: PropTypes.string.isRequired,

    deleteQueryFn: PropTypes.func.isRequired,
    onStartEdit: PropTypes.func.isRequired,
    isPendingFn: PropTypes.func.isRequired,
    toggleQueryEnabledFn: PropTypes.func.isRequired,
    getRunSingleQueryDataFn: PropTypes.func.isRequired

  },

  render() {
    return (
      <div className="table table-striped table-hover">
        <div className="thead">
          <div className="tr">
            <div className="th">
              <strong>Document / Query </strong>
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
          {this.props.querys.map((q) => this.renderQueryRow(q))}
        </div>
      </div>
    );
  },


  renderQueryRow(query) {
    // const propValue = (propName) => query.getIn([].concat(propName));
    const documentTitle = query.get('name');

    return (
      <div
        to={COMPONENT_ID + '-query-detail'}
        params={{
          config: this.props.configId,
          queryId: query.get('id')
        }}
        className="tr">
        <div className="td">
          {this.renderGoogleLink(query)}
        </div>
        <div className="td">
          <i className="kbc-icon-arrow-right" />
        </div>
        <div className="td">
      /* TODO*/
        </div>
        <div className="td text-right kbc-no-wrap">
          {this.renderEditButton(query)}
          {this.renderDeleteButton(query)}
          <ActivateDeactivateButton
            activateTooltip="Enable Query"
            deactivateTooltip="Disable Query"
            isActive={query.get('enabled')}
            isPending={this.props.isPendingFn(['toggle', query.get('id')])}
            onChange={() => this.props.toggleQueryEnabledFn(query.get('id'))}
          />
          <RunExtractionButton
            title="Run Extraction"
            component={COMPONENT_ID}
            runParams={ () => {
              return {
                config: this.props.configId,
                configData: this.props.getRunSingleQueryDataFn(query.get('id'))
              };
            }}
          >
            You are about to run extraction of {documentTitle}
          </RunExtractionButton>
        </div>
      </div>
    );
  },

  renderEditButton(query) {
    return (
      <button className="btn btn-link"
        onClick={() => this.props.onStartEdit(query)}>
        <Tooltip tooltip="Edit query extraction" placement="top">
          <i className="kbc-icon-pencil" />
        </Tooltip>
      </button>
    );
  },

  renderDeleteButton(query) {
    const isPending = this.props.isPendingFn(['delete', query.get('id')]);
    if (isPending) {
      return <span className="btn btn-link"><Loader/></span>;
    }
    return (
      <Tooltip placement="top" tooltip="Delete query">
        <Confirm
          title="Delete query"
          text={`Do you really want to delete extraction of query ${getDocumentTitle(query)}?`}
          buttonLabel="Delete"
          onConfirm={() => this.props.deleteQueryFn(query.get('id'))}
        >
          <button className="btn btn-link">
            <i className="kbc-icon-cup" />
          </button>
        </Confirm>
      </Tooltip>
    );
  }

});
