import React, {PropTypes} from 'react';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import InputMappingRowMySqlEditor from '../components/mapping/InputMappingRowMySqlEditor';
import InputMappingRowDockerEditor from '../components/mapping/InputMappingRowDockerEditor';
import InputMappingRowRedshiftEditor from '../components/mapping/InputMappingRowRedshiftEditor';
import InputMappingRowSnowflakeEditor from '../components/mapping/InputMappingRowSnowflakeEditor';
import resolveInputShowDetails from './resolveInputShowDetails';

const MODE_CREATE = 'create', MODE_EDIT = 'edit';

export default React.createClass({
  propTypes: {
    mode: PropTypes.oneOf([MODE_CREATE, MODE_EDIT]),
    mapping: PropTypes.object.isRequired,
    tables: PropTypes.object.isRequired,
    backend: PropTypes.string.isRequired,
    type: PropTypes.string.isRequired,
    otherDestinations: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired,
    onRequestHide: PropTypes.func.isRequired
  },

  isValid() {
    return !!this.props.mapping.get('source') &&
      !this.isDestinationDuplicate();
  },

  getInitialState() {
    return {
      isSaving: false
    };
  },

  isDestinationDuplicate() {
    return this.props.otherDestinations.contains(this.props.mapping.get('destination', '').toLowerCase());
  },

  render() {
    return (
      <Modal {...this.props} title="Input Mapping" bsSize="large" onChange={() => null}>
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
      initialShowDetails: resolveInputShowDetails(this.props.backend, this.props.type, this.props.mapping),
      isDestinationDuplicate: this.isDestinationDuplicate()
    };
    if (this.props.backend === 'mysql' && this.props.type === 'simple') {
      return React.createElement(InputMappingRowMySqlEditor, props);
    } else if (this.props.backend === 'redshift' && this.props.type === 'simple') {
      return React.createElement(InputMappingRowRedshiftEditor, props);
    } else if (this.props.backend === 'snowflake' && this.props.type === 'simple') {
      return React.createElement(InputMappingRowSnowflakeEditor, props);
    } else if (this.props.backend === 'docker') {
      return React.createElement(InputMappingRowDockerEditor, props);
    }
    return null;
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
