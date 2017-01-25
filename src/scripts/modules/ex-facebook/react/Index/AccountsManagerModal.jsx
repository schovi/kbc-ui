import React, {PropTypes} from 'react';
// import {List, Map} from 'immutable';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';

// import EmptyState from '../../../components/react/components/ComponentEmptyState';

export default React.createClass({

  propTypes: {
    accounts: PropTypes.object.isRequired,
    show: PropTypes.bool.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onHideFn: PropTypes.func,
    authorizedDescription: PropTypes.string,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired,
    onSaveAccounts: PropTypes.func.isRequired

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
            Setup Accounts
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="row">
            <div className="table kbc-table-border-vertical kbc-detail-table" style={{'border-bottom': 0}}>
              <div className="tr">
                <div className="td">
                  {this.renderAllAccounts()}
                </div>
                <div className="td">
                  {this.renderConfigAccounts()}
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
            isDisabled={false}
          />

        </Modal.Footer>
      </Modal>
    );
  },

  renderAllAccounts() {
    return 'TODO';
  },

  renderConfigAccounts() {
    return 'TODO';
  },


  handleSave() {
    this.props.onSaveAccounts().then(
      () => this.props.onHideFn()
    );
  }

});
