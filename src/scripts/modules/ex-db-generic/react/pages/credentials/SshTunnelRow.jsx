import React, {PropTypes} from 'react';
import Textarea from 'react-textarea-autosize';
import {Input, FormControls} from 'react-bootstrap';
import {Protected} from 'kbc-react-components';

const StaticText = FormControls.Static;

export default React.createClass({
  propTypes: {
    onChange: PropTypes.func,
    data: PropTypes.object,
    isEditing: PropTypes.bool
  },

  render() {
    return (
      <div className="row">
        {this.createInput('SSH host', 'sshHost', 'text', false)}
        {this.createInput('SSH user', 'user', 'text', false)}
        {this.createInput('SSH port', 'sshPort', 'number', false)}
        {this.renderPublicKey()}
      </div>
    );
  },

  renderPublicKey() {
    return (
      <div className="form-group">
        <label className="control-label col-sm-4">
          SSH Public Key
        </label>

      <Textarea
        disabled={true}
        label="SSH Key"
        type="textarea"
        value={this.props.data.getIn(['keys', 'public'])}
        onChange={this.handleChange.bind(this, ['keys', 'public'])}
        minRows={4}
        className="form-control"
      />
      </div>
    );
  },

  handleChange(propName, event) {
    this.props.onChange(this.props.data.setIn([].concat(propName), event.target.value));
  },

  createInput(labelValue, propName, type = 'text', isProtected = false) {
    if (this.props.isEditing) {
      return (
        <Input
          label={labelValue}
          type={type}
          value={this.props.data.get(propName)}
          labelClassName="col-xs-4"
          wrapperClassName="col-xs-8"
          onChange={this.handleChange.bind(this, propName)} />);
    } else if (isProtected) {
      return (
        <StaticText
          label={labelValue}
          labelClassName="col-xs-4"
          wrapperClassName="col-xs-8">
          <Protected>
            {this.props.data.get(propName)}
          </Protected>
        </StaticText>);
    } else {
      return (
        <StaticText
          label={labelValue}
          labelClassName="col-xs-4"
          wrapperClassName="col-xs-8">
          {this.props.data.get(propName)}
        </StaticText>);
    }
  }
});
