import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';
import {Check} from 'kbc-react-components';
import TableLink from '../../../components/react/components/StorageApiTableLinkEx';

export default React.createClass({
  mixins: [immutableMixin],

  propTypes: {
    destination: PropTypes.string.isRequired,
    incremental: PropTypes.bool.isRequired,
    primaryKey: PropTypes.object.isRequired,
    delimiter: PropTypes.string.isRequired,
    enclosure: PropTypes.string.isRequired,
    onStartChangeSettings: PropTypes.func.isRequired,
    isEditDisabled: PropTypes.bool.isRequired
  },

  onStartChangeSettings() {
    this.props.onStartChangeSettings();
  },

  renderPrimaryKey() {
    if (this.props.primaryKey.count() === 0) {
      return (
        <span className="muted">
          Primary key not set.
        </span>
      );
    } else {
      return this.props.primaryKey.toJS().join(', ');
    }
  },

  renderChangeSettings() {
    return (
      <div className="text-right">
        <button
          disabled={this.props.isEditDisabled}
          className="btn btn-link"
          onClick={this.onStartChangeSettings}>
          <span className="kbc-icon-pencil" /> Change Settings
        </button>
      </div>
    );
  },

  render() {
    // TODO destination jako link na tabulku, pokud existuje
    return (
      <div>
        <h3>Settings</h3>
        {this.renderChangeSettings()}
        <div className="form-horizontal">
          <div className="row col-md-12">
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
          <div className="row col-md-12">
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
          <div className="row col-md-12">
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
          <div className="row col-md-12">
            <div className="form-group">
              <label className="control-label col-xs-4">
                <span>Delimiter</span>
              </label>
              <div className="col-xs-8">
                <p className="form-control-static">
                  <code>
                    {this.props.delimiter}
                  </code>
                </p>
              </div>
            </div>
          </div>
          <div className="row col-md-12">
            <div className="form-group">
              <label className="control-label col-xs-4">
                <span>Enclosure</span>
              </label>
              <div className="col-xs-8">
                <p className="form-control-static">
                  <code>
                    {this.props.enclosure}
                  </code>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
