import React, {PropTypes} from 'react';
import {List} from 'immutable';
import {Panel, ListGroup, ListGroupItem} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';

export default React.createClass({
  propTypes: {
    authToken: PropTypes.string.isRequired,
    file: PropTypes.object,
    updateSheets: PropTypes.func.isRequired,
    onSelectFile: PropTypes.func.isRequired

  },

  render() {
    const {file} = this.props;
    const isLoading = file.getIn(['sheetsApi', 'isLoading']);
    const header = (
      <span>
        {this.props.file.get('name')}
        {isLoading ? <Loader /> : null }
      </span>
    );
    return (
      <Panel
        onClick={this.onPanelClick}
        header={header}
        collapsible={true}
        key={file.get('id')}
        eventKey={file.get('id')}
      >
        {isLoading ? <span> Loading sheets... </span>
         :
         <ListGroup
           key={file.get('id')}
         >
           {this.getFileSheets().map(this.renderSheetItem)}
         </ListGroup>
        }
      </Panel>
    );
  },

  renderSheetItem(sheet) {
    return (
      <ListGroupItem
        key={sheet.get('sheetId')}
        active={sheet.get('selected')}
        onClick={() => this.selectSheet(sheet)}
      >
        {sheet.get('sheetTitle')}
      </ListGroupItem>
    );
  },


  getFileSheets() {
    return this.props.file.getIn(['sheetsApi', 'sheets'], List());
  },


  selectSheet(sheet) {
    const isSelected = !!sheet.get('selected');
    const sheetId = sheet.get('sheetId');
    const sheetToUpdate = sheet.set('selected', !isSelected);
    const newSheets = this.getFileSheets().map((s) => s.get('sheetId') === sheetId ? sheetToUpdate : s);
    return this.props.updateSheets(newSheets);
  },

  onPanelClick() {
    this.props.onSelectFile(this.props.file.get('id'));
  }
});
