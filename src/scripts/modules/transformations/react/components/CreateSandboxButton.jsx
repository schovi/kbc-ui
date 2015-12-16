import React, {PropTypes} from 'react';
import CreateSandboxModal from '../modals/ConfigureSandbox';
import {OverlayTrigger, Tooltip} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    backend: PropTypes.string.isRequired,
    runParams: PropTypes.object.isRequired,
    mode: PropTypes.oneOf(['link', 'button'])
  },

  getDefaultProps() {
    return {
      mode: 'link'
    };
  },

  getInitialState() {
    return {
      isModalOpen: false
    };
  },

  openModal(e) {
    e.stopPropagation();
    e.preventDefault();
    this.setState({
      isModalOpen: true
    });
  },

  render() {
    if (this.props.mode === 'button') {
      return (
        <OverlayTrigger placement="top" overlay={React.createElement(Tooltip, null, 'Create sandbox')}>
          <button className="btn btn-link" onClick={this.openModal}>
            <i className="fa fa-fw fa-wrench"/>
            {this.renderModal()}
          </button>
        </OverlayTrigger>
      );
    } else {
      return (
        <a onClick={this.openModal}>
          <i className="fa fa-fw fa-wrench"/> Create Sandbox
          {this.renderModal()}
        </a>
      );
    }
  },

  renderModal() {
    return React.createElement(CreateSandboxModal, {
      show: this.state.isModalOpen,
      onHide: () => {
        this.setState({
          isModalOpen: false
        });
      },
      defaultMode: 'prepare',
      backend: this.props.backend,
      runParams: this.props.runParams
    });
  }
});