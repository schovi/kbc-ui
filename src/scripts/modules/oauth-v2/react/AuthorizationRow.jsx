import React, {PropTypes} from 'react';
import AuthorizationModal from './AuthorizationModal';
import Confirm from '../../../react/common/Confirm';
import {Loader} from 'kbc-react-components';
import EmptyState from '../../components/react/components/ComponentEmptyState';
import Tooltip from '../../../react/common/Tooltip';
import moment from 'moment';
export default React.createClass({

  propTypes: {
    componentId: PropTypes.string.isRequired,
    credentials: PropTypes.object,
    onResetCredentials: PropTypes.func.isRequired,
    id: PropTypes.string.isRequired,
    isResetingCredentials: PropTypes.bool,
    showHeader: PropTypes.bool
  },

  getInitialState() {
    return {
      showModal: false
    };
  },

  getDefaultProps() {
    return {
      showHeader: true
    }
  },

  render() {
    return (
      <div>
        {this.renderAuthorizationModal()}
        {this.renderHeader()}
        {this.isAuthorized() ? this.renderAuthorizedInfo() : this.renderAuth()}
      </div>
    );
  },

  renderHeader() {
    if (!this.props.showHeader){
      return null;
    }
    return (
      <h2>Authorization</h2>
    );
  },

  renderAuth() {
    return (
      <EmptyState>
        <p>No Account authorized</p>
        <button
          onClick={this.showModal}
          className="btn btn-success">
          <i className="fa fa-fw fa-user"/>
          Authorize Account
        </button>
      </EmptyState>
    );
  },

  renderAuthorizedInfo() {
    const created = this.props.credentials.get('created');
    const createdInfo = (
      <Tooltip tooltip={created} placement="top">
        <span>
        {moment(created).fromNow()}
        </span>
      </Tooltip>
    );
    const creator = this.props.credentials.getIn(['creator', 'description']);
    return (
      <div>
        Account authorized for <strong>{this.props.credentials.get('authorizedFor')}</strong>
        {!this.props.isResetingCredentials ?  (
           <Confirm
             text="Do you really want to reset the authorized account?"
             title="Reset Authorization"
             buttonLabel="Reset"
             onConfirm={this.props.onResetCredentials}>
             <a
               className="btn btn-link">
               Reset Authorization
             </a>
           </Confirm>
         ) : (
           <span>
             {' '}
             <Loader/>
           </span>
         )
        }
           <div className="small">
              {createdInfo} by {creator}
           </div>

      </div>
    );
  },

  renderAuthorizationModal() {
    return (
      <AuthorizationModal
        componentId={this.props.componentId}
        id={this.props.id}
        show={this.state.showModal}
        onHideFn={this.hideModal}
      />
    );
  },

  isAuthorized() {
    const creds = this.props.credentials;
    return  creds && creds.has('id');
  },

  hideModal() {
    this.setState(
      {showModal: false}
    );
  },

  showModal() {
    this.setState(
      {showModal: true}
    );
  }

});
