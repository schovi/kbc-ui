import React, {PropTypes} from 'react';
import {DragDropMixin} from 'react-dnd';
import _ from 'underscore';
import Tooltip from '../../../../../react/common/Tooltip';

export default React.createClass({
  mixins: [DragDropMixin],
  propTypes: {
    toggleHide: PropTypes.func.isRequired,
    phase: PropTypes.object.isRequired,
    onPhaseMove: PropTypes.func.isRequired,
    onBeginDrag: PropTypes.func.isRequired,
    onEndDrag: PropTypes.func.isRequired,
    togglePhaseIdChange: PropTypes.bool.isRequired
  },

  statics: {
    configureDragDrop: (register) => {
      register('phase', {
        dragSource: {beginDrag: (phaseRow) => {
          // TODO this.props.onBeginDrag(phaseRow.props.phase.get('id'));
          return {item: phaseRow.props.phase};
        }
        },
        dropTarget: {over: (phaseRow, phase) => {
          // TODO this.props.onEndDrag(phaseRow.props.phase.get('id'));
          phaseRow.props.onPhaseMove(phase.get('id'), phaseRow.props.phase.get('id'));
        }}});
    }
  },

  render() {
    const isDragging = this.getDragState('phase').isDragging;
    const style = {
      cursor: 'move',
      opacity: isDragging ? 0.5 : 1
    };
    const props = _.extend({style: style}, this.dragSourceFor('phase'), this.dropTargetFor('phase'));
    return (
      <tr {...props}
        onClick={this.onRowClick}>
        <td className="kb-orchestrator-task-drag text-center">
          <i className="fa fa-bars" />
        </td>
        <td colSpan="6">
          <div className="text-center form-group form-group-sm">
            <span className="label label-default kbc-label-rounded kbc-cursor-pointer">
              <span>{this.props.phase.get('id')} </span>
              <Tooltip
                tooltip="Change phase title">
                <span
                  onClick={this.toggleTitleChange}
                  className="kbc-icon-pencil"/>
              </Tooltip>
            </span>

          </div>
        </td>
      </tr>
    );
  },

  toggleTitleChange(e) {
    this.props.togglePhaseIdChange(this.props.phase.get('id'));
    this.onStopPropagation(e);
  },

  onRowClick(e) {
    this.props.toggleHide();
    e.preventDefault();
    e.stopPropagation();
  },

  onStopPropagation(e) {
    e.preventDefault();
    e.stopPropagation();
  }

  /* <TasksEditTableRow
     task=this.props.task
     component: @props.components.get(task.get('component'))
     disabled: @props.disabled
     key: task.get('id')
     onTaskDelete: @props.onTaskDelete
     onTaskUpdate: @props.onTaskUpdate
     onTaskMove: @props.onTaskMove
   */


});
