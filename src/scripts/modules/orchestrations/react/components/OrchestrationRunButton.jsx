import React from 'react';
import {Tooltip, OverlayTrigger, ModalTrigger} from 'react-bootstrap';
import RunOrchestrationModal from '../modals/RunOrchestration';
import {runOrchestration} from '../../ActionCreators';
import {startOrchestrationRunTasksEdit} from '../../ActionCreators';
import {cancelOrchestrationRunTasksEdit} from '../../ActionCreators';
import {Loader} from 'kbc-react-components';

export default React.createClass({
  propTypes: {
    orchestration: React.PropTypes.object.isRequired,
    tasks: React.PropTypes.object,
    notify: React.PropTypes.bool,
    tooltipPlacement: React.PropTypes.string
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
        tasks={this.props.tasks}
        notify={this.props.notify}
        onRequestRun={this.handleRunStart}
        onRequestCancel={this.handleRunCancel}
        />
    );
  },

  handleRunCancel() {
    cancelOrchestrationRunTasksEdit(this.props.orchestration.get('id'));
  },

  handleRunStart() {
    this.setState({
      isLoading: true
    });

    runOrchestration(this.props.orchestration.get('id'), (this.props.tasks) ? this.props.tasks : null, this.props.notify)
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
    startOrchestrationRunTasksEdit(this.props.orchestration.get('id'));
  }

});