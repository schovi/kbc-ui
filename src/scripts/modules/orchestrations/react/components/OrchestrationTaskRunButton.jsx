import React from 'react';
import {Tooltip, OverlayTrigger, ModalTrigger} from 'react-bootstrap';
import RunOrchestrationModal from '../modals/RunOrchestration';
import {Loader} from 'kbc-react-components';

export default React.createClass({
  propTypes: {
    orchestration: React.PropTypes.object.isRequired,
    task: React.PropTypes.object.isRequired,
    notify: React.PropTypes.bool,
    tooltipPlacement: React.PropTypes.string,
    onRun: React.PropTypes.func.isRequired
  },

  getDefaultProps() {
    return {
      notify: false,
      tooltipPlacement: 'top'
    };
  },

  getInitialState() {
    return {
      isLoading: false
    };
  },

  render() {
    return (
      <OverlayTrigger overlay={<Tooltip>Run</Tooltip>} key="run" placement={this.props.tooltipPlacement}>
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

    return this.props.onRun(this.props.task)
      .finally(() => {
        if (this.isMounted()) {
          this.setState({
            isLoading: false
          });
        }
      });
  },

  handleButtonClick(e) {
    e.preventDefault();
    e.stopPropagation();
  }

});