import React from 'react';
import {Modal, Input} from 'react-bootstrap';
import moment from 'moment';
import ImmutableRenderMixin from '../mixins/ImmutableRendererMixin';
import ConfirmButtons from './ConfirmButtons';

export default React.createClass({
  mixins: [ImmutableRenderMixin],

  propTypes: {
    version: React.PropTypes.object.isRequired,
    show: React.PropTypes.bool.isRequired,
    onClose: React.PropTypes.func.isRequired,
    onCopy: React.PropTypes.func.isRequired,
    newVersionName: React.PropTypes.string,
    onChangeName: React.PropTypes.func.isRequired
  },

  onChange(e) {
    this.props.onChangeName(e.target.value);
  },

  render() {
    return (
      <Modal show={this.props.show} onHide={this.props.onClose}>
        <Modal.Header closeButton>
          <Modal.Title>Version Copy</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <p>
            This will copy version #{this.props.version.get('version')} created {moment(this.props.version.get('created')).fromNow()} by {this.props.version.getIn(['creatorToken', 'description'], 'unknown')} to a new configuration.
          </p>
          <form className="form-horizontal">
            <Input
              type="text"
              label="New configuration name"
              labelClassName="col-xs-5"
              wrapperClassName="col-xs-7"
              value={this.props.newVersionName}
              onChange={this.onChange}
              autoFocus={true}
            />
          </form>
        </Modal.Body>
        <Modal.Footer>
          <ConfirmButtons
            isSaving={false}
            isDisabled={this.props.newVersionName === '' || !this.props.newVersionName}
            cancelLabel="Cancel"
            saveLabel="Copy"
            saveStyle="success"
            onCancel={this.props.onClose}
            onSave={this.props.onCopy}
            placement="right"
            showSave={true}
          />
        </Modal.Footer>
      </Modal>
    );
  }
});
