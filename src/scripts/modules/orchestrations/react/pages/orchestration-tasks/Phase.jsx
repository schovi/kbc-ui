import React, {PropTypes} from 'react/addons';
import PhaseModal from '../../modals/Phase';
import {ModalTrigger, OverlayTrigger, Tooltip} from 'react-bootstrap';

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    task: PropTypes.object.isRequired,
    onPhaseUpdate: React.PropTypes.func.isRequired
  },

  render() {
    if (parseInt(this.props.task.get('phase')) > 0) {
      return (
          <OverlayTrigger overlay={<Tooltip>Change Task Phase</Tooltip>} placement="top">
            <ModalTrigger modal={this.modal()}>
          <span className="label label-default kbc-cursor-pointer">
            <span>{this.props.task.get('phase')} </span>
            <span className="kbc-icon-pencil"/>
          </span>
            </ModalTrigger>
          </OverlayTrigger>
      );
    } else {
      return (
          <OverlayTrigger overlay={<Tooltip>Change Task Phase</Tooltip>} placement="top">
            <ModalTrigger modal={this.modal()}>
          <span className="label label-default kbc-cursor-pointer">
            <span>Set </span>
            <span className="kbc-icon-pencil"/>
          </span>
            </ModalTrigger>
          </OverlayTrigger>
      );
    }
  },

  modal() {
    return React.createElement(PhaseModal, {
      onPhaseUpdate: this.props.onPhaseUpdate,
      task: this.props.task
    });
  }

});