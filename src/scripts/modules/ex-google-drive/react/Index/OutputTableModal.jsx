import React, {PropTypes} from 'react';
import {Map} from 'immutable';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import {Modal} from 'react-bootstrap';
import {sanitizeTableName} from '../../common';

export default React.createClass({

  propTypes: {
    show: PropTypes.bool.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onHideFn: PropTypes.func,
    localState: PropTypes.object.isRequired,
    outputBucket: PropTypes.string.isRequired,
    savedSheets: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired,
    onSaveSheetFn: PropTypes.func.isRequired

  },

  render() {
    const sheet = this.props.localState.get('sheet', Map());
    const documentTitle = `${sheet.get('fileTitle')} / ${sheet.get('sheetTitle')}`;
    return (
      <Modal
        show={this.props.show}
        onHide={this.props.onHideFn}
      >
        <Modal.Header closeButton>
          <Modal.Title>
            Edit Output Table Name of {documentTitle}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="row">
            {this.renderEdit()}
          </div>
        </Modal.Body>
        <Modal.Footer>
          <ConfirmButtons
            isSaving={this.props.isSaving}
            onSave={this.handleSave}
            onCancel={this.props.onHideFn}
            placement="right"
            saveLabel="Save"
            isDisabled={this.invalidReason()}
          />
        </Modal.Footer>
      </Modal>
    );
  },

  handleSave() {
    const sanitized = sanitizeTableName(this.value());
    const sheet = this.props.localState.get('sheet');
    this.props.updateLocalState('dontValidate', true);
    return this.props.onSaveSheetFn(sheet.set('outputTable', sanitized)).then(this.props.onHideFn);
  },

  value() {
    const defaultValue = this.props.localState.getIn(['sheet', 'outputTable'], '');
    return this.props.localState.get('value', defaultValue).trim();
  },

  renderEdit() {
    const value = this.value();
    const sanitized = sanitizeTableName(value);
    const err = this.invalidReason();
    return (
      <div className="col-md-12">
        <div className={'form-group'}>
          <div className="col-md-12">
            <span className={err ? 'has-error' : ''}>
              <div className="input-group">
                <div className="input-group-addon">
                  <small>{this.props.outputBucket}</small>.
                </div>
                <input
                  type="text"
                  className="form-control"
                  value={value}
                  onChange={this.onChange}/>
              </div>
              {
                err ?
                <span className="help-block">
                  {err}
                </span>
                : null
              }
            </span>
            {
              sanitized !== value ?
              <span className="help-block">
                Table name will be sanitized to {sanitized}
              </span>
              : null
            }
          </div>
        </div>
      </div>
    );
  },

  invalidReason() {
    if (this.props.localState.get('dontValidate')) return null;
    const value = this.value();
    if (!value || value.length === 0) return 'Can not be empty.';
    const sanitized = sanitizeTableName(value);
    const savedValue = this.props.localState.getIn(['sheet', 'outputTable']);
    if (savedValue !== sanitized && this.props.savedSheets.find((s) => s.get('outputTable') === sanitized)) return `Table name ${sanitized} already exists in the configuration.`;
    return null;
  },

  onChange(e) {
    const newVal = e.target.value;
    this.props.updateLocalState('value', newVal);
  }

});
