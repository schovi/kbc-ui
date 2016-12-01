import React, {PropTypes} from 'react';
import {Map} from 'immutable';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import {Modal} from 'react-bootstrap';
import {sanitizeTableName, sheetFullName} from '../../common';
import ProcessorControls from '../components/ProcessorControls';

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
    const documentTitle = sheetFullName(sheet, ' / ');
    const headerRowValue = this.headerRowValue();

    return (
      <Modal
        bsSize="large"
        show={this.props.show}
        onHide={this.props.onHideFn}
      >
        <Modal.Header closeButton>
          <Modal.Title>
            Edit Extraction of {documentTitle}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="form-horizontal clearfix">
            <div className="row">
              {this.renderEdit()}
            </div>
          </div>
        </Modal.Body>
        <Modal.Footer>
          <ConfirmButtons
            isSaving={this.props.isSaving}
            onSave={this.handleSave}
            onCancel={this.props.onHideFn}
            placement="right"
            saveLabel="Save"
            isDisabled={Boolean(this.invalidReason()) || isNaN(headerRowValue) || headerRowValue < 1}
          />
        </Modal.Footer>
      </Modal>
    );
  },

  renderEdit() {
    const value = this.outputTableValue();
    const sanitized = sanitizeTableName(value);
    const err = this.invalidReason();

    return (
      <div className="col-md-12">
        <div className="form-group">
          <label className="control-label col-sm-4">
            Output Table
          </label>
          <div className="col-sm-8">

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

        <ProcessorControls
          {...this.props.prepareLocalState(['ProcessorControl'])}
        />

      </div>
    );
  },


  handleSave() {
    const sanitized = sanitizeTableName(this.outputTableValue());
    const sheet = this.props.localState.get('sheet');
    this.props.updateLocalState('dontValidate', true);
    const newSheet = sheet
      .set('outputTable', sanitized)
      .setIn(['header', 'row'], this.headerRowValue())
      .setIn(['processor', 'headerRow'], this.headerRowValue())
      .setIn(['processor', 'headerColumnNames'], this.headerColumnNamesValue())
      .setIn(['processor', 'transposeHeaderRow'], this.transposeHeaderRowValue())
      .setIn(['processor', 'transposedHeaderColumnName'], this.transposedHeaderColumnNameValue())
    ;
    return this.props.onSaveSheetFn(newSheet).then(this.props.onHideFn);
  },

  outputTableValue() {
    const defaultValue = this.props.localState.getIn(['sheet', 'outputTable'], '');
    return this.props.localState.get('value', defaultValue).trim();
  },

  headerRowValue() {
    const defaultValue = this.props.localState.getIn(['sheet', 'header', 'row'], 1);
    return this.props.localState.get('headerRow', defaultValue);
  },

  invalidReason() {
    if (this.props.localState.get('dontValidate')) return null;
    const value = this.outputTableValue();
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
