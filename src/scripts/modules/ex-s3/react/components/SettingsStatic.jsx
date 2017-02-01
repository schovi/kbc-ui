import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';
import {Check} from 'kbc-react-components';
import TableLink from '../../../components/react/components/StorageApiTableLinkEx';

export default React.createClass({
  mixins: [immutableMixin],

  propTypes: {
    s3Bucket: PropTypes.string.isRequired,
    s3Key: PropTypes.string.isRequired,
    wildcard: PropTypes.bool.isRequired,
    destination: PropTypes.string.isRequired,
    incremental: PropTypes.bool.isRequired,
    primaryKey: PropTypes.array.isRequired
  },

  renderPrimaryKey() {
    if (this.props.primaryKey.length === 0) {
      return (
        <span className="muted">
          Not set
        </span>
      );
    } else {
      return this.props.primaryKey.join(', ');
    }
  },

  render() {
    return (
      <div className="form-horizontal row">
        <div className="col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-4">
              <span>Bucket</span>
            </label>
            <div className="col-xs-8">
              <p className="form-control-static">
                {this.props.s3Bucket || 'Not set'}
              </p>
            </div>
          </div>
        </div>
        <div className="col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-4">
              <span>Key</span>
            </label>
            <div className="col-xs-8">
              <p className="form-control-static">
                {this.props.s3Key || 'Not set'}
              </p>
            </div>
          </div>
        </div>
        <div className="col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-4">
              <span>Wildcard</span>
            </label>
            <div className="col-xs-8">
              <p className="form-control-static">
                <Check isChecked={this.props.wildcard} />
              </p>
            </div>
          </div>
        </div>
        <div className="col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-4">
              <span>Destination</span>
            </label>
            <div className="col-xs-8">
              <p className="form-control-static">
                <TableLink
                  tableId={this.props.destination}
                  >
                  {this.props.destination}
                </TableLink>
              </p>
            </div>
          </div>
        </div>
        <div className="col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-4">
              <span>Incremental</span>
            </label>
            <div className="col-xs-8">
              <p className="form-control-static">
                <Check isChecked={this.props.incremental} />
              </p>
            </div>
          </div>
        </div>
        <div className="col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-4">
              <span>Primary key</span>
            </label>
            <div className="col-xs-8">
              <p className="form-control-static">
                {this.renderPrimaryKey()}
              </p>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
