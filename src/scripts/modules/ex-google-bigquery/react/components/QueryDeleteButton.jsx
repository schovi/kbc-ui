import React, {PropTypes} from 'react';
import Tooltip from '../../../../react/common/Tooltip';
import {Loader} from 'kbc-react-components';
import Confirm from '../../../../react/common/Confirm';

export default React.createClass({
  propTypes: {
    query: PropTypes.object.isRequired,
    onDeleteFn: PropTypes.func.isRequired,
    isPending: PropTypes.bool,
    tooltipPlacement: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      tooltipPlacement: 'top'
    };
  },

  render() {
    if (this.props.isPending) {
      return <span className="btn btn-link"><Loader/></span>;
    }


    return (
      <Tooltip placement="top" tooltip="Delete query" placement={this.props.tooltipPlacement}
        >
        <Confirm
          title="Delete Query"
          text={`Do you really want to delete query ${this.props.query.get('name')}?`}
          buttonLabel="Delete"
          onConfirm={() => this.props.onDeleteFn(this.props.query)}
        >
          <button className="btn btn-link">
            <i className="kbc-icon-cup" />
          </button>
        </Confirm>
      </Tooltip>
    );
  }

});
