import React, {PropTypes} from 'react';
import {Modal, Input} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import actionCreators from '../../ActionCreators';

export default React.createClass({
  propTypes: {
    value: PropTypes.object.isRequired,
    transformation: React.PropTypes.object.isRequired,
    bucket: React.PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired,
    onRequestHide: PropTypes.func.isRequired
  },

  componentDidMount() {
    actionCreators.startTransformationFieldEdit(this.props.bucket.get('id'), this.props.transformation.get('id'), 'snowflake');
  },


  isValid() {
    return true;
  },

  getInitialState() {
    return {
      isSaving: false
    };
  },

  render() {
    return (
      <Modal {...this.props} title="Snowflake DB connection configuration" bsSize="large" onChange={() => null}>
        <div className="modal-body">
          {this.editor()}
        </div>
        <div className="modal-footer">
          <ConfirmButtons
            saveLabel="Save"
            isSaving={this.state.isSaving}
            onCancel={this.handleCancel}
            onSave={this.handleSave}
            isDisabled={!this.isValid()}
            />
        </div>
      </Modal>
    );
  },

  editor() {
    return (<span>
        <div className="form-horizontal clearfix">
          <div className="row col-md-12">
            <Input
              bsSize="small"
              type="text"
              label="Hostname"
              value={this.props.value.get('host', '')}
              placeholder="Snowflake DB hostname, eg. keboola.snowflakecomputing.com"
              onChange={this.handleChangeHost}
              disabled={this.state.isSaving}
              labelClassName="col-xs-3"
              wrapperClassName="col-xs-9"
              />
          </div>
          <div className="row col-md-12">
            <Input
              bsSize="small"
              type="text"
              label="Port"
              value={this.props.value.get('port', '')}
              placeholder="Snowflake DB port, eg. 443"
              onChange={this.handleChangePort}
              disabled={this.state.isSaving}
              labelClassName="col-xs-3"
              wrapperClassName="col-xs-9"
              />
          </div>
          <div className="row col-md-12">
            <Input
              bsSize="small"
              type="text"
              label="Account name"
              value={this.props.value.get('account', '')}
              placeholder="Snowflake account name"
              onChange={this.handleChangeAccount}
              disabled={this.state.isSaving}
              labelClassName="col-xs-3"
              wrapperClassName="col-xs-9"
              />
          </div>
          <div className="row col-md-12">
            <Input
              bsSize="small"
              type="text"
              label="Username"
              value={this.props.value.get('user', '')}
              placeholder="Snowflake login username"
              onChange={this.handleChangeUser}
              disabled={this.state.isSaving}
              labelClassName="col-xs-3"
              wrapperClassName="col-xs-9"
              />
          </div>
          <div className="row col-md-12">
            <Input
              bsSize="small"
              type="password"
              label="Encrypted password"
              value={this.props.value.get('#password', this.props.value.get('password', ''))}
              placeholder="Encrypted Snowflake login password"
              onChange={this.handleChangePassword}
              disabled={this.state.isSaving}
              labelClassName="col-xs-3"
              wrapperClassName="col-xs-9"
              />
          </div>
          <div className="row col-md-12">
            <Input
              bsSize="small"
              type="text"
              label="Database"
              value={this.props.value.get('database', '')}
              placeholder="Snowflake database "
              onChange={this.handleChangeDatabase}
              disabled={this.state.isSaving}
              labelClassName="col-xs-3"
              wrapperClassName="col-xs-9"
              />
          </div>
          <div className="row col-md-12">
            <Input
              bsSize="small"
              type="text"
              label="Schema"
              value={this.props.value.get('schema', '')}
              placeholder="Snowflake schema name"
              onChange={this.handleChangeSchema}
              disabled={this.state.isSaving}
              labelClassName="col-xs-3"
              wrapperClassName="col-xs-9"
              />
          </div>
          <div className="row col-md-12">
            <Input
              bsSize="small"
              type="text"
              label="Warehouse"
              value={this.props.value.get('warehouse', '')}
              placeholder="Snowflake warehouse"
              onChange={this.handleChangeWarehouse}
              disabled={this.state.isSaving}
              labelClassName="col-xs-3"
              wrapperClassName="col-xs-9"
              />
          </div>
        </div>
      </span>
    );
  },

  handleChangeHost(e) {
    var value;
    value = this.props.value.set('host', e.target.value);
    this.props.onChange(value);
  },

  handleChangePort(e) {
    var value;
    value = this.props.value.set('port', e.target.value);
    this.props.onChange(value);
  },

  handleChangeAccount(e) {
    var value;
    value = this.props.value.set('account', e.target.value);
    this.props.onChange(value);
  },

  handleChangeUser(e) {
    var value;
    value = this.props.value.set('user', e.target.value);
    this.props.onChange(value);
  },

  handleChangePassword(e) {
    var value;
    value = this.props.value.set('#password', e.target.value);
    if (value.get('password')) {
      value = value.delete('password');
    }
    this.props.onChange(value);
  },

  handleChangeDatabase(e) {
    var value;
    value = this.props.value.set('database', e.target.value);
    this.props.onChange(value);
  },

  handleChangeSchema(e) {
    var value;
    value = this.props.value.set('schema', e.target.value);
    this.props.onChange(value);
  },

  handleChangeWarehouse(e) {
    var value;
    value = this.props.value.set('warehouse', e.target.value);
    this.props.onChange(value);
  },

  handleCancel() {
    this.props.onRequestHide();
    this.props.onCancel();
  },

  handleSave() {
    this.setState({
      isSaving: true
    });
    this.props
      .onSave()
      .then(() => {
        this.setState({
          isSaving: false
        });
        this.props.onRequestHide();
      })
      .catch((e) => {
        this.setState({
          isSaving: false
        });
        throw e;
      });
  }

});
