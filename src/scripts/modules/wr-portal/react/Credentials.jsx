import React, {PropTypes} from 'react';
import {FormControls} from 'react-bootstrap';
import {Protected} from 'kbc-react-components';
import Clipboard from '../../../react/common/Clipboard';
const StaticText = FormControls.Static;

export default React.createClass({

  propTypes: {
    credentials: PropTypes.object
  },

  render() {
    return (
      <form className="form-horizontal">
        <div className="col-md-12">
          {this.renderInput('Host', 'hostname')}
          {this.renderInput('Port', 'port')}
          {this.renderInput('User', 'user')}
          {this.renderInput('Password', 'password', true)}
          {this.renderInput('Database', 'db')}
          {this.renderInput('Schema', 'schema')}
        </div>
      </form>
    );
  },

  renderInput(labelValue, propName, isProtected = false) {
    if (isProtected) {
      return (
        <StaticText
          label={labelValue}
          labelClassName="col-xs-4"
          wrapperClassName="col-xs-8">
          <Protected>
            {this.props.credentials.get(propName)}
          </Protected>
          <Clipboard text={this.props.credentials.get(propName)}/>
        </StaticText>);
    } else {
      return (
        <StaticText
          label={labelValue}
          labelClassName="col-xs-4"
          wrapperClassName="col-xs-8">
          {this.props.credentials.get(propName)}
          <Clipboard text={this.props.credentials.get(propName)}/>
        </StaticText>
      );
    }
  }
});
