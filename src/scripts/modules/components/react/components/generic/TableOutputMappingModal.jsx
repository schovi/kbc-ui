import React, {PropTypes} from 'react';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';
import Editor from './TableOutputMappingEditor';
import resolveOutputShowDetails from './resolveOutputShowDetails';
const MODE_CREATE = 'create', MODE_EDIT = 'edit';
import validateStorageTableId from '../../../../../utils/validateStorageTableId';
import Immutable from 'immutable';

export default React.createClass({
  propTypes: {
    mode: PropTypes.oneOf([MODE_CREATE, MODE_EDIT]),
    mapping: PropTypes.object.isRequired,
    tables: PropTypes.object.isRequired,
    buckets: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired,
    onRequestHide: PropTypes.func.isRequired,
    definition: PropTypes.object
  },


  getDefaultProps: function() {
    return {
      definition: Immutable.Map()
    };
  },

  isValid() {
    return (this.props.definition.has('source') || !!this.props.mapping.get('source')) &&
      !!this.props.mapping.get('destination') &&
      validateStorageTableId(this.props.mapping.get('destination', ''));
  },

  getInitialState() {
    return {
      isSaving: false
    };
  },

  render() {
    var title = 'Output Mapping';
    if (this.props.definition.get('label')) {
      title = this.props.definition.get('label');
    }
    return (
      <Modal {...this.props} title={title} bsSize="large" onChange={() => null}>
        <div className="modal-body">
          {this.editor()}
        </div>
        <div className="modal-footer">
          <ConfirmButtons
            saveLabel={this.props.mode === MODE_CREATE ? 'Create' : 'Save'}
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
    const props = {
      value: this.props.mapping,
      tables: this.props.tables,
      buckets: this.props.buckets,
      disabled: this.state.isSaving,
      onChange: this.props.onChange,
      backend: 'docker',
      definition: this.props.definition,
      initialShowDetails: resolveOutputShowDetails(this.props.mapping)
    };
    return React.createElement(Editor, props);
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
