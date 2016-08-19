import React, {PropTypes} from 'react';
import {List} from 'immutable';
import {Panel, ListGroup, ListGroupItem} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';

export default React.createClass({
  propTypes: {
    authToken: PropTypes.string.isRequired,
    file: PropTypes.object,
    selectSheet: PropTypes.func.isRequired,
    onSelectFile: PropTypes.func.isRequired

  },

  render() {
    const {file} = this.props;
    const isLoading = this.isLoading();
    const header = (
      <span>
        <span className="table">
          <span className="tbody">
            <span className="tr">
              <span className="td">
                {this.props.file.get('name')}
                {' '}
                {isLoading ? <Loader /> : null }
              </span>
            </span>
          </span>
        </span>
      </span>
    );
    return (
      <Panel
        onSelect={this.onPanelClick}
        header={header}
        expanded={file.get('isExpanded')}
        collapsible={true}
        key={file.get('id')}
        eventKey={file.get('id')}
      >
        {isLoading ? <span> Loading sheets... </span>
         :
         <div className="row">
           <ListGroup key={file.get('id')}>
             {this.getFileSheets().map(this.renderSheetItem).toArray()}
           </ListGroup>
         </div>
        }
      </Panel>

    );
  },

  isLoading() {
    return this.props.file.getIn(['sheetsApi', 'isLoading'], false);
  },

  renderSheetItem(sheet) {
    return (
      <ListGroupItem
        key={sheet.get('sheetId')}
        active={!!sheet.get('selected')}
        disabled={false}
        onClick={() => this.props.selectSheet(this.props.file, sheet)}
      >
        {sheet.get('sheetTitle')}
      </ListGroupItem>
    );
  },


  getFileSheets() {
    return this.props.file.getIn(['sheetsApi', 'sheets'], List());
  },

  onPanelClick(e) {
    e.preventDefault();
    e.stopPropagation();
    this.props.onSelectFile(this.props.file.get('id'));
  }
});
