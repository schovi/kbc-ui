import React, {PropTypes} from 'react';
// import {Map} from 'immutable';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import {Modal} from 'react-bootstrap';
// import {sanitizeTableName, sheetFullName} from '../../common';

export default React.createClass({

  propTypes: {
    show: PropTypes.bool.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onHideFn: PropTypes.func,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    onSaveFn: PropTypes.func.isRequired

  },

  render() {
    return (
      <Modal
        bsSize="large"
        show={this.props.show}
        onHide={this.props.onHideFn}
      >
        <Modal.Header closeButton>
          <Modal.Title>
            Setup AntiSampling
            <div>
              <small> Choose from one of the following antisampling algorithms </small>
            </div>
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="form-horizontal clearfix">
            <div className="row">
              {this.renderBody()}
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
          />
        </Modal.Footer>
      </Modal>
    );
  },

  handleSave() {
    return;
  },

  renderBody() {
    return (
      <div className="col-md-12">
        <div className="form-group">
          <label className="control-label col-sm-3">
            AntiSampling Algorithms
          </label>
          <div className="col-sm-9">
            <div className="radio">
              <label>
                <input type="radio" name="optionsRadios" id="optionsRadios1" value="option1" checked/>
                Daily Walk - desc TBA
              </label>
            </div>
            <div className="radio">
              <label>
                <input type="radio" name="optionsRadios" id="optionsRadios1" value="option1" checked/>
                Somethin other - desc TBA
              </label>
            </div>
            <div className="radio">
              <label>
                <input type="radio" name="optionsRadios" id="optionsRadios1" value="option1" checked/>
                None
              </label>
            </div>
          </div>
        </div>

      </div>
    );
  },

  onChange(e) {
    const newVal = e.target.value;
    this.props.updateLocalState('value', newVal);
  }

});
