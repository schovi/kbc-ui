import React, {PropTypes} from 'react/addons';
import PhaseModal from '../../modals/Phase';
import {ModalTrigger, OverlayTrigger, Tooltip} from 'react-bootstrap';

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    transformation: PropTypes.object.isRequired,
    bucketId: PropTypes.string.isRequired
  },

  render() {
    console.log('render phase');
    return (
      <OverlayTrigger overlay={<Tooltip>Change Transformation Phase</Tooltip>} placement="top">
        <ModalTrigger modal={this.modal()}>
          <span className="label kbc-label-rounded-small label-default kbc-cursor-pointer">
            Phase: {this.props.transformation.get('phase')}
            <span className="kbc-icon-pencil"/>
          </span>
        </ModalTrigger>
      </OverlayTrigger>
    );
  },

  modal() {
    return React.createElement(PhaseModal, {
      transformation: this.props.transformation,
      bucketId: this.props.bucketId
    });
  }

});