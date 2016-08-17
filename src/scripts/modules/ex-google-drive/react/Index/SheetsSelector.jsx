import React, {PropTypes} from 'react';
import {Panel/* , ListGroup, ListGroupItem*/} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    authToken: PropTypes.string.isRequired,
    file: PropTypes.object,
    onSelectSheet: PropTypes.func.isRequired,
    selectedSheets: PropTypes.object
  },

  render() {
    const {file} = this.props;
    const header = (<span> {this.props.file.get('title')} </span>);
    return (
      <Panel
        onClick={this.onPanelClick}
        header={header}
        collapsible={true}
        key={file.get('id')}
        eventKey={file.get('id')}
      >
        panel
      </Panel>
    );
  },

  onPanelClick() {
    this.loadSheetsFromFile();
  },

  loadSheetsFromFile() {
    // TODO: spreadsheet npm lib failed, do it directly via google sheet api
  },

  onFileoaded(fileInfo) {
    console.log('FILE LOADED', fileInfo);
  }

});
