import React from 'react';
import {Protected, Loader} from 'kbc-react-components';
import Clipboard from '../../../../react/common/Clipboard';

module.exports = React.createClass({
  displayName: 'RStudioCredentials',
  propTypes: {
    credentials: React.PropTypes.object,
    isCreating: React.PropTypes.bool
  },
  render: function() {
    if (this.props.isCreating) {
      return (
        <div>
          <span>
            <Loader />
            &nbsp;Creating sandbox
          </span>
        </div>
      );
    } else if (this.props.credentials.get('id')) {
      return (
        <div>
          {this._renderCredentials()}
        </div>
      );
    } else {
      return (
        <div>
          Sandbox not running
        </div>
      );
    }
  },
  _renderCredentials: function() {
    return (
      <span>
        <div className="row">
          <span className="col-md-3">Host</span>
          <span className="col-md-9">
            {this.props.credentials.get('hostname')}
            <Clipboard text={this.props.credentials.get('hostname')}/>
          </span>
        </div>
        <div className="row">
          <span className="col-md-3">Port</span>
          <span className="col-md-9">
            {this.props.credentials.get('port')}
            <Clipboard text={this.props.credentials.get('port').toString()}/>
          </span>
        </div>
        <div className="row">
          <span className="col-md-3">User</span>
          <span className="col-md-9">
            {this.props.credentials.get('user')}
            <Clipboard text={this.props.credentials.get('user')}/>
          </span>
        </div>
        <div className="row">
          <span className="col-md-3">Password</span>
          <span className="col-md-9">
            <Protected>{this.props.credentials.get('password')}</Protected>
            <Clipboard text={this.props.credentials.get('password')}/>
          </span>
        </div>
      </span>
    );
  }
});

