import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import Sticky from 'react-sticky';
import {Input} from 'react-bootstrap';


export default React.createClass({
  propTypes: {
    data: PropTypes.object.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired,
    saveLabel: PropTypes.string
  },

  getDefaultProps() {
    return {
      saveLabel: 'Save configuration'
    };
  },

  onChangeRepository(e) {
    this.props.onChange(this.props.data.set('repository', e.target.value));
  },

  onChangeVersion(e) {
    this.props.onChange(this.props.data.set('version', e.target.value));
  },

  onChangeNetwork(e) {
    if (e.target.checked) {
      this.props.onChange(this.props.data.set('network', 'bridge'));
    } else {
      this.props.onChange(this.props.data.set('network', 'none'));
    }
  },

  onChangeUsername(e) {
    this.props.onChange(this.props.data.set('username', e.target.value));
  },

  onChangePassword(e) {
    this.props.onChange(this.props.data.set('#password', e.target.value));
  },

  render() {
    return (
      <div>
        <p className="help-block">This information should be provided by application developer.</p>
        <div className="edit kbc-configuration-editor">
          <Sticky stickyClass="kbc-sticky-buttons-active" className="kbc-sticky-buttons" topOffset={-60} stickyStyle={{}}>
            <ConfirmButtons
              isSaving={this.props.isSaving}
              onSave={this.props.onSave}
              onCancel={this.props.onCancel}
              placement="right"
              saveLabel={this.props.saveLabel}
              />
          </Sticky>

          <div className="form-horizontal">
            <div className="row col-md-12">
              <Input
                type="text"
                label="Repository"
                labelClassName="col-xs-3"
                wrapperClassName="col-xs-9"
                value={this.props.data.get('repository', '')}
                onChange={this.onChangeRepository}
                help="GitHub or Bitbucket repository URL"
                placeholder="https://github.com/keboola/my-r-app"
                />
            </div>

            <div className="row col-md-12">
              <Input
                type="text"
                label="Version"
                labelClassName="col-xs-3"
                wrapperClassName="col-xs-9"
                value={this.props.data.get('version', '')}
                onChange={this.onChangeVersion}
                help={(<span>Branch or tag in the repository. Using <code>master</code> as version is inefficient and should not be used in production setup. We recommend using <a href="http://semver.org/">Semantic versioning</a>.</span>)}
                placeholder="1.0.0"
                />
            </div>

            <div className="row col-md-12">
              <div className="col-xs-9 col-xs-offset-3">
                <Input
                  type="checkbox"
                  label="Allow application to access the Internet"
                  labelClassName="col-xs-12"
                  checked={this.props.data.get('network', 'bridge') === 'bridge'}
                  onChange={this.onChangeNetwork}
                  help="Preventing access to the Internet may cause the application to fail. Please consult with application author(s)."
                  />
              </div>
            </div>

            <div className="row col-md-12">
              <Input
                type="text"
                label="Username"
                labelClassName="col-xs-3"
                wrapperClassName="col-xs-9"
                value={this.props.data.get('username', '')}
                onChange={this.onChangeUsername}
                help="Username and password are required only for private repositories"
                placeholder=""
                />
            </div>

            <div className="row col-md-12">
              <Input
                type="password"
                label="Password"
                labelClassName="col-xs-3"
                wrapperClassName="col-xs-9"
                value={this.props.data.get('#password', '')}
                onChange={this.onChangePassword}
                help="Password will be kept encrypted"
                />
            </div>

          </div>
        </div>
      </div>
    );
  }
});
