import React, {PropTypes} from 'react';
import {Modal, Input} from 'react-bootstrap';
import ConfirmButtons from '../../../react/common/ConfirmButtons';

export default React.createClass({
  propTypes: {
    credentials: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired,
    onHide: PropTypes.func.isRequired,
    isSaving: PropTypes.bool.isRequired,
    show: PropTypes.bool.isRequired
  },

  render() {
    return (
      <Modal show={this.props.show} onHide={this.props.onHide}>
        <Modal.Header closeButton>
          <Modal.Title>Credentials</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <p>Please fill your Adform credentials</p>
          <div className="form-horizontal">
            <Input
              type="text"
              label="Username"
              value={this.props.credentials.get('username')}
              onChange={this.handleChange.bind(this, 'username')}
              labelClassName='col-xs-4' wrapperClassName='col-xs-6'
              />
            <Input
              type="password"
              label="Password"
              value={this.props.credentials.get('password')}
              onChange={this.handleChange.bind(this, 'password')}
              labelClassName='col-xs-4' wrapperClassName='col-xs-6'
              />
          </div>
        </Modal.Body>
        <Modal.Footer>
          <ConfirmButtons
            isSaving={this.props.isSaving}
            isDisabled={this.props.isSaving || !this.isValid()}
            onSave={this.handleSave}
            onCancel={this.props.onHide}
            />
        </Modal.Footer>
      </Modal>
    );
  },

  isValid() {
    return this.props.credentials.get('username').trim().length > 0 &&
      this.props.credentials.get('password').trim().length > 0;
  },

  handleChange(field, e) {
    this.props.onChange(this.props.credentials.set(field, e.target.value));
  },

  handleSave() {
    this.props.onSave().then(() => this.props.onHide());
  }

});