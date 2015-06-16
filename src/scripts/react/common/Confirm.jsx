import React from 'react';
import {ModalTrigger} from 'react-bootstrap';
import ConfirmModal from './ConfirmModal';

export default React.createClass({
  propTypes: {
    title: React.PropTypes.string.isRequired,
    text: React.PropTypes.string.isRequired,
    onConfirm: React.PropTypes.func.isRequired,
    buttonLabel: React.PropTypes.string.isRequired,
    buttonType: React.PropTypes.string,
    children: React.PropTypes.any
  },

  getDefaultProps() {
    return {
      buttonType: 'danger'
    };
  },

  render() {
    return (
      <ModalTrigger {...this.props} modal={<ConfirmModal {...this.props}/>}>
        {React.cloneElement(React.Children.only(this.props.children), {
          onClick: (e) => {
            e.preventDefault();
            e.stopPropagation();
          }
        })}
      </ModalTrigger>
    );
  }

});
