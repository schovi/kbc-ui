import React, {PropTypes} from 'react';

import {Input} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    destination: PropTypes.string.isRequired,
    incremental: PropTypes.bool.isRequired,
    primaryKey: PropTypes.object.isRequired,
    onStartUpload: PropTypes.func.isRequired,
    onChange: PropTypes.func.isRequired,
    isValid: PropTypes.bool.isRequired
  },

  onSubmit() {
    this.props.onStartUpload();
  },

  onChange(e) {
    this.props.onChange(e.target.files[0]);
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
            />
        </div>
        <div className="row col-md-12">
          <Input
            type="text"
            label="Escape character"
            labelClassName="col-xs-4"
            wrapperClassName="col-xs-8"
            disabled={true}
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

      </div>
    );
  }
});
