import React, {PropTypes} from 'react';
import {List} from 'immutable';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import {Loader} from 'kbc-react-components';
import {ListGroup, ListGroupItem} from 'react-bootstrap';

// import EmptyState from '../../../components/react/components/ComponentEmptyState';

export default React.createClass({

  propTypes: {
    accounts: PropTypes.object.isRequired,
    syncAccounts: PropTypes.object.isRequired,
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

  renderConfigAccounts() {

  },

  renderAllAccounts() {
    if (this.props.syncAccounts.get('isLoading')) return (<Loader />);
    const data = this.props.syncAccounts.get('data', List());
    console.log('data', data, this.props);
    return (
      <ListGroup>
        {data.map((d) =>
          <ListGroupItem>
            {d.get('name')}
          </ListGroupItem>
         )}
      </ListGroup>
    );
  },

  handleSave() {
    this.props.onSaveAccounts().then(
      () => this.props.onHideFn()
    );
  }

});
