import React, {PropTypes} from 'react';
import {Map, List, fromJS} from 'immutable';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';

import GdrivePicker from '../../../google-utils/react/GooglePicker';
// import ApplicationActionCreators from '../../../../actions/ApplicationActionCreators';
import EmptyState from '../../../components/react/components/ComponentEmptyState';

// import './ProfilesManagerModal.less';
import ViewTemplates from '../../../google-utils/react/PickerViewTemplates';
import {listSheets} from '../../../google-utils/react/SheetsApi';
import SheetsSelector from './SheetsSelector';

function remapSheets(sheets) {
  const newSheets = sheets.map((sheet) => {
    const s = sheet.properties;
    return {
      sheetId: s.sheetId,
      sheetTitle: s.title
    };
  });
  return newSheets;
}

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
          buttonLabel="Select spreadsheet document from Google Drive..."
          onPickedFn={this.onPickSpreadsheet}
          requireSheetsApi={true}
          views={[
            ViewTemplates.sharedSheets,
            ViewTemplates.sheets,
            ViewTemplates.recent
          ]}
        />
        {this.props.localState.get('files', List()).map((file) =>
          <SheetsSelector
            file={file}
            onSelectFile={this.selectFile}
            updateSheets={(newSheets) => this.updateFile(file.get('id'), file.setIn(['sheetsApi', 'sheets'], newSheets))}
          />
         )}
      </span>
    );
  },

  selectFile(fileId) {
    const sheetsApi = this.getFileSheets(fileId);
    if (sheetsApi.get('isLoading') || sheetsApi.get('sheets')) return;
    this.loadFileSheets(fileId);
  },

  getFileSheets(fileId) {
    return this.getFile(fileId).get('sheetsApi', Map());
  },

  getFile(fileId) {
    const files = this.props.localState.get('files', List());
    return files.find((f) => f.get('id') === fileId);
  },

  updateFile(fileId, newFile) {
    const newFiles = this.props.localState.get('files', List()).map((f) => f.get('id') === fileId ? newFile : f);
    this.props.updateLocalState('files', newFiles);
  },

  loadFileSheets(fileId) {
    const file = this.getFile(fileId);
    this.updateFile(fileId, file.setIn(['sheetsApi', 'isLoading'], true));
    return listSheets(fileId).then((sheets) => {
      console.log('SHEETS', sheets);
      return this.updateFile(fileId, file.set('sheetsApi', fromJS({
        isLoading: false,
        sheets: remapSheets(sheets.result.sheets)
      })));
    });
  },

  addFiles(filesToAdd) {
    let files = this.props.localState.get('files', List());
    for (let file of filesToAdd) {
      if (!this.getFile(file.id)) files = files.push(fromJS(file));
    }
    this.props.updateLocalState('files', files);
  },

  onPickSpreadsheet(data) {
    console.log('PICKED PYCO', data);
    const docs = data.filter((f) => f.type === 'document');
    this.addFiles(docs);
  },

  renderSelectedSheets() {
    const files = this.props.localState.get('files', List()).filter((f) => {
      return f.getIn(['sheetsApi', 'sheets'], List()).find((s) => s.get('selected'));
    });

    return (
      <div>
        <h3> Selected Sheets </h3>
        {files.map((f) => f.get('title'))}
        <EmptyState>
          No profiles selected.
        </EmptyState>
      </div>
    );
  }
});
