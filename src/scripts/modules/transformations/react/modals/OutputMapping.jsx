import React, {PropTypes} from 'react';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import OutputMappingRowEditor from '../components/mapping/OutputMappingRowEditor';

const MODE_CREATE = 'create', MODE_EDIT = 'edit';

export default React.createClass({
  propTypes: {
    mode: PropTypes.oneOf([MODE_CREATE, MODE_EDIT]),
    mapping: PropTypes.object.isRequired,
    tables: PropTypes.object.isRequired,
    buckets: PropTypes.object.isRequired,
    backend: PropTypes.string.isRequired,
    type: PropTypes.string.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired
  },

  isValid() {
    return !!this.props.mapping.get('source') && !!this.props.mapping.get('destination');
  },

  getInitialState() {
    return {
      isSaving: false
    };
  },

  render() {
    return (
      <Modal {...this.props} title="Output Mapping" bsSize="large" onChange={() => null}>
        <div className="modal-body">
          <OutputMappingRowEditor
            fill={true}
            value={this.props.mapping}
            tables={this.props.tables}
            buckets={this.props.buckets}
            onChange={this.props.onChange}
            disabled={this.state.isSaving}
            backend={this.props.backend}
            type={this.props.type}
            />
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
