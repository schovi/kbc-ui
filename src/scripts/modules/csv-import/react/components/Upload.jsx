import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';
import {ProgressBar} from 'react-bootstrap';

export default React.createClass({
  mixins: [immutableMixin],

  propTypes: {
    onStartUpload: PropTypes.func.isRequired,
    onChange: PropTypes.func.isRequired,
    isValid: PropTypes.bool.isRequired,
    isUploading: PropTypes.bool.isRequired,
    uploadingMessage: PropTypes.string.isRequired,
    uploadingProgress: PropTypes.number.isRequired
  },

  onChange(e) {
    this.props.onChange(e.target.files[0]);
  },

  uploadStatus() {
    if (!this.props.isUploading) {
      return null;
    }
    return (
      <div className="row col-md-12">
        <div className="col-xs-8 col-xs-offset-4">
          <p className="form-control-static">
            {this.props.uploadingMessage}
            <ProgressBar
              active
              now={this.props.uploadingProgress}
              />
          </p>
        </div>
      </div>
    );
  },

  uploadButton() {
    if (this.props.isUploading) {
      return null;
    }
    return (
      <div className="row col-md-12">
        <div className="col-xs-8 col-xs-offset-4">
          <div className="form-group">
            <button
              className="btn btn-success"
              title="Upload"
              onClick={this.props.onStartUpload}
              disabled={!this.props.isValid}
            >
              Upload
            </button>
          </div>
        </div>
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
                  className="form-control-static"
                  type="file"
                  label="Select file"
                  onChange={this.onChange}
                  disabled={this.props.isUploading}
                />
              </div>
            </div>
          </div>
          {this.uploadStatus()}
          {this.uploadButton()}

        </div>
      </div>
    );
  }
});
