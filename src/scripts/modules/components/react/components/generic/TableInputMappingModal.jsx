import React, {PropTypes} from 'react';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';
import Editor from './TableInputMappingEditor';
import resolveInputShowDetails from './resolveInputShowDetails';

const MODE_CREATE = 'create', MODE_EDIT = 'edit';

export default React.createClass({
  propTypes: {
    mode: PropTypes.oneOf([MODE_CREATE, MODE_EDIT]),
    mapping: PropTypes.object.isRequired,
    tables: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired,
    title: PropTypes.string,
    onRequestHide: PropTypes.func.isRequired,
    otherDestinations: PropTypes.object.isRequired,
    showFileHint: PropTypes.bool
  },

  getDefaultProps() {
    return {
      title: 'Input Mapping',
      showFileHint: true
    };
  },

  isValid() {
    return !!this.props.mapping.get('source')
      && !!this.props.mapping.get('destination')
      && !this.isDestinationDuplicate();
  },

  getInitialState() {
    return {
      isSaving: false
    };
  },

  isDestinationDuplicate() {
    if (this.props.otherDestinations) {
      return this.props.otherDestinations.contains(this.props.mapping.get('destination', '').toLowerCase());
    } else {
      return false;
    }
  },

  render() {
    return (
      <Modal {...this.props} title={this.props.title} bsSize="large" onChange={() => null}>
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
      disabled: this.state.isSaving,
      onChange: this.props.onChange,
      initialShowDetails: resolveInputShowDetails(this.props.mapping),
      isDestinationDuplicate: this.isDestinationDuplicate(),
      showFileHint: this.props.showFileHint
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
