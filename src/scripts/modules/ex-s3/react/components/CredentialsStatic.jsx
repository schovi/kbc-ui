import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';

export default React.createClass({
  mixins: [immutableMixin],

  propTypes: {
    awsAccessKeyId: PropTypes.string.isRequired,
    awsSecretAccessKey: PropTypes.string.isRequired
  },

  renderAWSSecretAccessKey() {
    if (this.props.awsSecretAccessKey !== '') {
      return (
        <span className="fa fa-fw fa-lock"></span>
      );
    } else {
      return 'Not set';
    }
  },

  render() {
    return (
      <div className="form-horizontal row">
        <div className="col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-4">
              <span>Access Key ID</span>
            </label>
            <div className="col-xs-8">
              <p className="form-control-static">
                {this.props.awsAccessKeyId || 'Not set'}
              </p>
            </div>
          </div>
        </div>
        <div className="col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-4">
              <span>Secret Key</span>
            </label>
            <div className="col-xs-8">
              <p className="form-control-static">
                {this.renderAWSSecretAccessKey()}
              </p>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
