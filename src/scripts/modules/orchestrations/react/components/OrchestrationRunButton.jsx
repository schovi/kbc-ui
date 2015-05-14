import React from 'react';
import {Tooltip, OverlayTrigger, ModalTrigger} from 'react-bootstrap';
import RunOrchestrationModal from '../modals/RunOrchestration';
import {runOrchestration} from '../../ActionCreators';
import Loader from '../../../../react/common/Loader';

export default React.createClass({
  propTypes: {
    orchestration: React.PropTypes.object.isRequired,
    notify: React.PropTypes.bool
  },

  getDefaultProps() {
    return {
      notify: false
    };
  },

  getInitialState() {
    return {
      isLoading: false
    };
  },

  render() {
    return (
      <OverlayTrigger overlay={<Tooltip>Run</Tooltip>} key="run" placement="top">
        <ModalTrigger modal={this.modal()}>
          <button className="btn btn-link" onClick={this.handleButtonClick}>
            {this.icon()}
          </button>
        </ModalTrigger>
      </OverlayTrigger>
    );
  },

  icon() {
    if (this.state.isLoading) {
      return (
        <Loader className="fa-fw"/>
      );
    } else {
      return (
        <i className="fa fa-fw fa-play"/>
      );
    }
  },

  modal() {
    return (
      <RunOrchestrationModal
        orchestration={this.props.orchestration}
        notify={this.props.notify}
        onRequestRun={this.handleRunStart}
        />
    );
  },

  handleRunStart() {
    this.setState({
      isLoading: true
    });
    runOrchestration(this.props.orchestration.get('id'), this.props.notify)
    .finally(() => {
      this.setState({
        isLoading: false
      });
    });
  },

  handleButtonClick(e) {
    e.preventDefault();
    e.stopPropagation();
  }

});