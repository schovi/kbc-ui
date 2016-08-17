import React, {PropTypes} from 'react';
import {List} from 'immutable';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';

import GdrivePicker from '../../../google-utils/react/GooglePicker';
// import ApplicationActionCreators from '../../../../actions/ApplicationActionCreators';
import EmptyState from '../../../components/react/components/ComponentEmptyState';

// import './ProfilesManagerModal.less';
import ViewTemplates from '../../../google-utils/react/PickerViewTemplates';
import SheetsSelector from './SheetsSelector';
export default React.createClass({

  propTypes: {
    show: PropTypes.bool.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onHideFn: PropTypes.func,
    authorizedEmail: PropTypes.string,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired,
    onSaveSheets: PropTypes.func.isRequired
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
            Add Sheets
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="row">
            <div className="table kbc-table-border-vertical kbc-detail-table" style={{'border-bottom': 0}}>
              <div className="tr">
                <div className="td">
                  {this.renderSheetsSelector()}
                </div>
                <div className="td">
                  {this.renderSelectedSheets()}
                </div>
              </div>
            </div>
          </div>
        </Modal.Body>
        <Modal.Footer>
          <ConfirmButtons
            isSaving={this.props.isSaving}
            onSave={this.handleSave}
            onCancel={this.props.onHideFn}
            placement="right"
            saveLabel="Save Changes"
            isDisabled={true}
          />

        </Modal.Footer>
      </Modal>
    );
  },

  renderSheetsSelector() {
    return (
      <span>
        <GdrivePicker
          email={this.props.authorizedEmail}
          dialogTitle="Select a spreadsheet document"
          bucttonLabel="Select spreadsheet document from Google Drive..."
          onPickedFn={this.onPickSpreadsheet}
          views={[
            ViewTemplates.sharedSheets,
            ViewTemplates.sheets,
            ViewTemplates.recent
          ]}
        />
        {this.props.localState.get('files', List()).map((file) =>
          <SheetsSelector
            authToken={this.props.localState.get('authToken')}
            file={file}
            onSelectSheet={() => true}
            selectedSheets={this.props.localState.getIn([file.get('id'), 'selectedSheets'])}
          />
         )}
      </span>
    );
  },

  /* setAuthToken(token) {
   *   this.props.updateLocalState('authToken', token);
   * },*/

  onPickSpreadsheet(data) {
    const docs = data.filter((f) => f.type === 'document');
    this.props.updateLocalState('files', List(docs));
  },

  renderSelectedSheets() {
    return (
      <div>
        <h3> Selected Sheets </h3>
        <EmptyState>
          No profiles selected.
        </EmptyState>
      </div>
    );
  }
});
