import React, {PropTypes} from 'react';
import {Input, Button} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';
import {OrderedMap} from 'immutable';

export default React.createClass({
  propTypes: {
    parameters: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    onRun: PropTypes.func.isRequired,
    isValid: PropTypes.bool.isRequired,
    isSaving: PropTypes.bool.isRequired,
    savedMessage: PropTypes.object
  },

  componentDidMount() {
    this.refs.awsAccessKeyId.getInputDOMNode().focus();
  },

  render() {
    return (
      <div className="form-horizontal">
        {this.input('AWS Access Key ID', 'awsAccessKeyId', '')}
        {this.input('AWS Secret Access Key', '#awsSecretAccessKey', '', 'password')}
        <Input
          type="select"
          labelClassName="col-xs-4"
          wrapperClassName="col-xs-8"
          label="S3 Region"
          value={this.props.parameters.get('s3region')}
          onChange={this.handleChange.bind(this, 's3region')}
          >
            {this.regionOptions()}
          </Input>
        {this.input('S3 Bucket', 's3bucket', 'my-bucket')}
        {this.input('S3 path', 's3path', 'Optional path in S3')}
        <Input type="checkbox"
           wrapperClassName="col-xs-offset-4 col-xs-8"
           label="Export project structure only"
           help="Only bucket and table metadata and component configurations will be exported."
           checked={this.props.parameters.get('onlyStructure')}
           onChange={this.handleOnlyStructureChange}
        />
        <div className="form-group">
          <div className="col-xs-offset-4 col-xs-8">
            <p className="help-block">
              Data wil be exported to <strong>{this.s3Path()}</strong>
            </p>
          </div>
        </div>
        <div className="form-group">
          <div className="col-xs-offset-4 col-xs-8">
            <Button bsStyle="success" onClick={this.props.onRun} disabled={!this.props.isValid || this.props.isSaving}>
              Run Export
            </Button> {this.loader()} {this.props.savedMessage}
          </div>
        </div>
      </div>
    );
  },

  input(label, field, placeholder, type = 'text') {
    return React.createElement(Input, {
      type: type,
      label: label,
      ref: field,
      placeholder: placeholder,
      value: this.props.parameters.get(field),
      onChange: this.handleChange.bind(this, field),
      labelClassName: 'col-xs-4',
      wrapperClassName: 'col-xs-8'
    });
  },

  s3Path() {
    const s3path = `s3://${this.props.parameters.get('s3bucket')}`,
      path = this.props.parameters.get('s3path');
    if (!this.props.parameters.get('s3bucket')) {
      return s3path;
    }
    if (!path) {
      return s3path + '/';
    }
    return s3path + (path[0] === '/' ? path : `/${path}`);
  },

  regionOptions() {
    const regions = OrderedMap({
      'us-east-1': 'US Standard (N. Virginia)',
      'us-west-2': 'US West (Oregon)',
      'us-west-1': 'US West (N. California)',
      'eu-west-1': 'EU (Ireland)',
      'eu-central-1': 'EU (Frankfurt)',
      'ap-southeast-1': 'Asia Pacific (Singapore)',
      'ap-southeast-2': 'Asia Pacific (Sydney)',
      'ap-northeast-1': 'Asia Pacific (Tokyo)',
      'sa-east-1': 'South America (Sao Paulo)'
    });
    return regions.map((regionName, regionValue) => {
      return <option value={regionValue} key={regionValue}>{regionName}</option>;
    });
  },

  loader() {
    return this.props.isSaving ? React.createElement(Loader) : null;
  },

  handleChange(field, event) {
    console.log('change', event, event.target.value);
    this.props.onChange(this.props.parameters.set(field, event.target.value));
  },

  handleOnlyStructureChange(event) {
    this.props.onChange(this.props.parameters.set('onlyStructure', event.target.checked));
  }
});