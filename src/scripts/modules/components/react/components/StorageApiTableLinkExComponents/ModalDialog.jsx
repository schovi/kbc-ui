import React, {PropTypes} from 'react'

import {Input, Table, Modal} from 'react-bootstrap';


export default React.createClass ({

  propTypes:{
    show: PropTypes.bool.isRequired,
    tableId: PropTypes.string.isRequired,
    reload: PropTypes.func.isRequired,
    tableExists: PropTypes.func.isRequired

  },

  render(){
    const modalBody = this.renderModalBody();
    let tableLink = (<small className="disabled btn btn-link"> Explore in Console</small>);
    if (this.props.tableExists()){
      tableLink =
      (
        <SapiTableLink
          tableId={this.props.tableId}>
          <small className="btn btn-link">
            Explore in Console
          </small>
        </SapiTableLink>);


    }
    return (
      <div className="static-modal">
        <Modal
          bsSize="large"
          show={this.props.show}
          onHide={this.onHide}
          >
          <Modal.Header closeButton>
            <Modal.Title>
              {this.props.tableId}
              {tableLink}
              <RefreshIcon
                 isLoading={this.isLoading()}
                 onClick={this.props.reload}
              />
            </Modal.Title>
          </Modal.Header>
          <Modal.Body>
            {modalBody}
          </Modal.Body>
        </Modal>
      </div>
    );

  },

  renderModalBody(){
    return (
      <TabbedArea key="tabbedarea" animation={false}>
        <TabPane key="general" eventKey="general" tab="General Info">
          {this.renderGeneralInfo()}
        </TabPane>
        <TabPane key="columns" eventKey="columns" tab="Columns">
          {this.renderColumnsInfo()}
        </TabPane>
        <TabPane key="datasample" eventKey="datasample" tab="Data Sample">
          {this.renderDataSample()}
        </TabPane>
        <TabPane key="events" eventKey="events" tab="Events">
          {this.renderEvents()}
        </TabPane>
      </TabbedArea>
    );

  },

});
