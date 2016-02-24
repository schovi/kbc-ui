import React, {PropTypes} from 'react';
import AuthorizationModal from './AuthorizationModal';

export default React.createClass({

  propTypes: {
    componentId: PropTypes.string.isRequired,
    id: PropTypes.string.isRequired
  },

  getInitialState() {
    return {
      showModal: false
    };
  },

  render() {
    return (
      <div>
        {this.renderAuthorizationModal()}
        <h2> Authorization
        </h2>
        <button
          onClick={this.showModal}
          className="btn btn-primary">
          Authorize
        </button>
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
