import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';
import {Check} from 'kbc-react-components';

export default React.createClass({
  mixins: [immutableMixin],

  propTypes: {
    destination: PropTypes.string.isRequired,
    incremental: PropTypes.bool.isRequired,
    primaryKey: PropTypes.object.isRequired,
    delimiter: PropTypes.string.isRequired,
    enclosure: PropTypes.object.isRequired,
    onStartUpload: PropTypes.func.isRequired,
    onChange: PropTypes.func.isRequired,
    onStartChangeSettings: PropTypes.func.isRequired,
    isValid: PropTypes.bool.isRequired,
    isUploading: PropTypes.bool.isRequired,
    uploadingMessage: PropTypes.string.isRequired
  },

  onSubmit() {
    this.props.onStartUpload();
  },

  onChange(e) {
    this.props.onChange(e.target.files[0]);
  },

  onStartChangeSettings() {
    this.props.onStartChangeSettings();
  },

  uploadStatus() {
    if (!this.props.isUploading) {
      return null;
    }
    return (
      <div className="row col-md-12">
        <div className="col-xs-8 col-xs-offset-4">
          State: {this.props.uploadingMessage}
        </div>
      </div>
    );
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
        <button className="btn btn-link" onClick={this.onStartChangeSettings.bind(this, 0)}>
          <span className="kbc-icon-pencil"></span> Change Settings
        </button>
      </div>
    );
  },

  render() {
    return (
      <div>
        <h3>Upload CSV File</h3>
        <div className="form-horizontal">
          <div className="row col-md-12">
            <div className="form-group">
              <label className="control-label col-xs-4">
                <span>Select file</span>
              </label>
              <div className="col-xs-8">
                <input
                  type="file"
                  label="Select file"
                  onChange={this.onChange}
                />
              </div>
            </div>
          </div>
          <div className="row col-md-12">
            <div className="col-xs-8 col-xs-offset-4">
              <div className="form-group">
                <button
                  className="btn btn-success"
                  title="Upload"
                  onClick={this.onSubmit}
                  disabled={!!this.props.isValid}
                >
                  Upload
                </button>
              </div>
            </div>
          </div>
          {this.uploadStatus()}
        </div>
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
                  {this.props.destination}
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
