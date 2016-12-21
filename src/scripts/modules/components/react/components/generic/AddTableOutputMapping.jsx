import React from 'react';
import {ModalTrigger} from 'react-bootstrap';
import Modal from './TableOutputMappingModal';
import actionCreators from '../../../InstalledComponentsActionCreators';

export default React.createClass({
  propTypes: {
    tables: React.PropTypes.object.isRequired,
    buckets: React.PropTypes.object.isRequired,
    mapping: React.PropTypes.object.isRequired,
    componentId: React.PropTypes.string.isRequired,
    configId: React.PropTypes.string.isRequired
  },

  render() {
    return (
      <ModalTrigger modal={this.modal()}>
        <button className="btn btn-primary" onClick={this.handleClick}>
          <span className="kbc-icon-plus" /> Add Table Output
        </button>
      </ModalTrigger>
    );
  },

  modal() {
    return React.createElement(Modal, {
      mode: 'create',
      mapping: this.props.mapping,
      tables: this.props.tables,
      buckets: this.props.buckets,
      onChange: this.handleChange,
      onCancel: this.handleCancel,
      onSave: this.handleSave
    });
  },

  handleClick(e) {
    e.preventDefault();
    e.stopPropagation();
  },

  /* eslint camelcase: 0 */
  handleChange(newMapping) {
    actionCreators.changeEditingMapping(this.props.componentId,
      this.props.configId,
      'output',
      'tables',
      'new-mapping',
      newMapping
    );
  },

  handleCancel() {
    actionCreators.cancelEditingMapping(this.props.componentId,
      this.props.configId,
      'output',
      'tables',
      'new-mapping'
    );
  },

  handleSave() {
    const newTableId = this.props.mapping.get('destination');
    // returns promise
    return actionCreators.saveEditingMapping(this.props.componentId,
      this.props.configId,
      'output',
      'tables',
      'new-mapping',
      `Add output table ${newTableId}`
    );
  }

});
