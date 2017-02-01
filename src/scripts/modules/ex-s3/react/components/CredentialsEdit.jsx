import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';
import {Input} from 'react-bootstrap';

export default React.createClass({
  mixins: [immutableMixin],

  propTypes: {
    awsAccessKeyId: PropTypes.string.isRequired,
    awsSecretAccessKey: PropTypes.string.isRequired,
    onChange: PropTypes.func.isRequired
  },

  onChangeAwsAccessKeyId(e) {
    this.props.onChange('awsAccessKeyId', e.target.value);
  },

  onChangeAwsSecretAccessKey(e) {
    this.props.onChange('awsSecretAccessKey', e.target.value);
  },

  render() {
    return (
      <div className="row form-horizontal">
        <div className="col-md-12">
          <Input
            type="text"
            label="Access Key Id"
            labelClassName="col-xs-4"
            wrapperClassName="col-xs-8"
            value={this.props.awsAccessKeyId}
            onChange={this.onChangeAwsAccessKeyId}
            placeholder="MYAWSACCESSKEYID123"
            help={(
              <span>
                Make sure that this AWS Access Key ID has correct permissions. Required permissions are
                <ul>
                  <li><code>s3:GetObject</code> for the given key/wildcard</li>
                  <li><code>s3:ListBucket</code> to access all wildcard files</li>
                  <li><code>s3:GetBucketLocation</code> to determine bucket region</li>
                </ul>
                More information is available in the <a href="https://help.keboola.com/extractors/other/aws-s3/">documentation</a>.
              </span>
            )}
            />
        </div>
        <div className="col-md-12">
          <Input
            type="password"
            label="Secret Access Key"
            labelClassName="col-xs-4"
            wrapperClassName="col-xs-8"
            value={this.props.awsSecretAccessKey}
            onChange={this.onChangeAwsSecretAccessKey}
            help={(<span>The AWS Secret Access Key will be encrypted.</span>)}
            />
        </div>
      </div>
    );
  }
});
