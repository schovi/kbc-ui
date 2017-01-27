import React, {PropTypes} from 'react';
import {List, Map} from 'immutable';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import {Loader} from 'kbc-react-components';
import SearchRow from '../../../../react/common/SearchRow';
// import {ListGroup, ListGroupItem} from 'react-bootstrap';

import EmptyState from '../../../components/react/components/ComponentEmptyState';

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
            Setup Pages
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="row">
            <div className="col-xs-6">
              <div>
                <h4 className="text-center">All Pages of {this.props.authorizedDescription}</h4>
                <SearchRow
                  className="small"
                  query={this.localState(['filter'])}
                  onChange={(newVal) => this.updateLocalState(['filter'], newVal)}
                />
                {this.renderAllAccounts()}
              </div>
            </div>
            <div className="col-xs-6">
              <div>
                <h4 className="text-center">Selected Pages</h4>
                {this.renderConfigAccounts()}
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
            isDisabled={this.props.accounts.equals(this.localState(['selected']))}
          />

        </Modal.Footer>
      </Modal>
    );
  },

  renderConfigAccounts() {
    const accounts = this.localState(['selected'], Map());
    if (accounts.count() > 0) {
      return (
        <table className="table table-striped table-hover">
          <tbody>
            {accounts.map((a) =>
              <tr>
                <td>
                  {a.get('name') || a.get('id')}
                </td>
                <td>
                  <span onClick={this.deselectAccount.bind(this, a.get('id'))}
                    className="kbc-icon-cup kbc-cursor-pointer" />
                </td>
              </tr>
             ).toArray()}
          </tbody>
        </table>
      );
    } else {
      return (<EmptyState> No Pages Selected </EmptyState>);
    }
  },

  renderAllAccounts() {
    if (this.props.syncAccounts.get('isLoading')) return (<Loader />);
    let data = this.props.syncAccounts.get('data', List());
    data = data.filter((a) => !this.localState(['selected'], Map()).has(a.get('id')));
    if (!!this.localState(['filter'], '')) {
      data = data.filter((a) => a.get('name')
                                 .toLowerCase()
                                 .includes(this.localState(['filter'], '').toLowerCase()));
    }

    if (data.count() > 0) {
      return (
        <table className="table table-striped table-hover kbc-tasks-list">
          <tbody>
            {data.map((d) =>
              <tr>
                <td>
                  <a
                    key={d.get('id')}
                    onClick={this.selectAccount.bind(this, d)}>
                    {d.get('name')}
              <span className="kbc-icon-arrow-right pull-right" />
                  </a>
                </td>
              </tr>
             ).toArray()}
          </tbody>
        </table>
      );
    } else {
      return (<EmptyState>No pages</EmptyState>);
    }
  },

  deselectAccount(accountId) {
    const accounts = this.localState(['selected'], Map()).remove(accountId);
    this.updateLocalState(['selected'], accounts);
  },

  selectAccount(account) {
    const accounts = this.localState(['selected'], Map());
    this.updateLocalState(['selected'], accounts.set(account.get('id'), account));
  },

  localState(path, defaultVal) {
    return this.props.localState.getIn(path, defaultVal);
  },

  updateLocalState(path, newValue) {
    return this.props.updateLocalState([].concat(path), newValue);
  },

  handleSave() {
    this.props.onSaveAccounts(this.localState(['selected'], Map())).then(
      () => this.props.onHideFn()
    );
  }

});
