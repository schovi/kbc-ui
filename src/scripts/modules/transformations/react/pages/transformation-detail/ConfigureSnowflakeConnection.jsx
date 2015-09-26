import React from 'react';
import {ModalTrigger} from 'react-bootstrap';
import ConfigureSnowflakeConnectionModal from '../../modals/ConfigureSnowflakeConnection';
import actionCreators from '../../../ActionCreators';

export default React.createClass({
  propTypes: {
    connection: React.PropTypes.object.isRequired,
    transformation: React.PropTypes.object.isRequired,
    bucket: React.PropTypes.object.isRequired,
    children: React.PropTypes.node
  },

  render() {
    return (
      <ModalTrigger modal={this.modal()}>
        <a>
          <span className="fa fa-cog fa-fw"></span>
          <span>
            &nbsp;Snowflake connection
          </span>
        </a>
      </ModalTrigger>
    );
  },

  modal() {
    return React.createElement(ConfigureSnowflakeConnectionModal, {
      value: this.props.connection,
      transformation: this.props.transformation,
      bucket: this.props.bucket,
      onChange: this.handleChange,
      onCancel: this.handleCancel,
      onSave: this.handleSave
    });
  },

  handleClick(e) {
    e.preventDefault();
    e.stopPropagation();
  },

  handleChange(newValue) {
    actionCreators.updateTransformationEditingField(this.props.bucket.get('id'),
      this.props.transformation.get('id'),
      'snowflake',
      newValue
    );
  },

  handleCancel() {
    actionCreators.cancelTransformationEditingField(this.props.bucket.get('id'),
      this.props.transformation.get('id'),
      'snowflake'
    );
  },

  handleSave() {
    // returns promise
    return actionCreators.saveSnowflakeConnection(this.props.bucket.get('id'),
      this.props.transformation.get('id')
    );
  }

});
