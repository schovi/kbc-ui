import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';
import {Input} from 'react-bootstrap';

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

  render() {
    return (
      <div>
        <div className="row col-md-12">
          <Input
            type="file"
            label="Select file"
            labelClassName="col-xs-4"
            wrapperClassName="col-xs-8"
            onChange={this.onChange}
            />
        </div>
        <div className="row col-md-12">
          <Input
            type="text"
            label="Destination"
            labelClassName="col-xs-4"
            wrapperClassName="col-xs-8"
            disabled={true}
            value={this.props.destination}
            />
        </div>
        <div className="row col-md-12">
          <div className="col-xs-8 col-xs-offset-4">
            <Input
              type="checkbox"
              label="Incremental"
              labelClassName="col-xs-4"
              wrapperClassName="col-xs-8"
              disabled={true}
              />
          </div>
        </div>
        <div className="row col-md-12">
          <Input
            type="text"
            label="Primary key"
            labelClassName="col-xs-4"
            wrapperClassName="col-xs-8"
            disabled={true}
            value={this.props.primaryKey}
            />
        </div>
        <div className="row col-md-12">
          <Input
            type="text"
            label="Delimiter"
            labelClassName="col-xs-4"
            wrapperClassName="col-xs-8"
            disabled={true}
            value={this.props.delimiter}
            />
        </div>
        <div className="row col-md-12">
          <Input
            type="text"
            label="Enclosure"
            labelClassName="col-xs-4"
            wrapperClassName="col-xs-8"
            disabled={true}
            value={this.props.enclosure}
            />
        </div>
        <div className="row col-md-12">
          <div className="col-xs-8 col-xs-offset-4">
            <Input
              type="submit"
              title="Upload"
              labelClassName="col-xs-4"
              wrapperClassName="col-xs-8"
              onClick={this.onSubmit}
              disabled={!!this.props.isValid}
              />
          </div>
        </div>
        {this.uploadStatus()}
      </div>
    );
  }
});
