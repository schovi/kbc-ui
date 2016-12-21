import React, {PropTypes} from 'react';
import {Check} from 'kbc-react-components';

export default React.createClass({
  propTypes: {
    data: PropTypes.object.isRequired,
    onEditStart: PropTypes.func.isRequired,
    editLabel: PropTypes.string
  },

  getDefaultProps() {
    return {
      editLabel: 'Edit configuration'
    };
  },

  renderUsernamePassword() {
    // do not display if username and password not set
    if (!this.props.data.get('username') && !this.props.data.get('#password')) {
      return null;
    }
    return (
      <span>
        <div className="row col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-3">
              <span>Username</span>
            </label>
            <div className="col-xs-9">
              <p className="form-control-static">
                {this.props.data.get('username', 'Not set')}
              </p>
            </div>
          </div>
        </div>

        <div className="row col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-3">
              <span>Password</span>
            </label>
            <div className="col-xs-9">
              <p className="form-control-static">
                <Check isChecked={this.props.data.has('#password') && this.props.data.get('#password')} />
              </p>
            </div>
          </div>
        </div>
      </span>
    );
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil" /> {this.props.editLabel}
      </button>
    );
  },

  render() {
    return (
      <div className="edit kbc-configuration-editor">
        <div className="text-right">{this.startEditButton()}</div>
        <div className="form-horizontal">

          <div className="row col-md-12">
            <div className="form-group">
              <label className="control-label col-xs-3">
                <span>Repository</span>
              </label>
              <div className="col-xs-9">
                <p className="form-control-static">
                  {this.props.data.get('repository', 'Not set')}
                </p>
              </div>
            </div>
          </div>

          <div className="row col-md-12">
            <div className="form-group">
              <label className="control-label col-xs-3">
                <span>Version</span>
              </label>
              <div className="col-xs-9">
                <p className="form-control-static">
                  <code>
                    {this.props.data.get('version', 'Not set')}
                  </code>
                </p>
              </div>
            </div>
          </div>

          <div className="row col-md-12">
            <div className="form-group">
              <label className="control-label col-xs-3">
                <span>Internet access</span>
              </label>
              <div className="col-xs-9">
                <p className="form-control-static">
                  <Check isChecked={this.props.data.get('network', 'bridge') === 'bridge'} />
                </p>
              </div>
            </div>
          </div>

          {this.renderUsernamePassword()}

        </div>
      </div>
    );
  }
});
