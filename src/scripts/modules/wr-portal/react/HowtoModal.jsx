import React, {PropTypes} from 'react';
import {Modal} from 'react-bootstrap';
import HowtoTemplates from './howtoTemplates/HowtoTemplates';

export default React.createClass({
  propTypes: {
    show: PropTypes.bool,
    onHide: PropTypes.func,
    componentId: PropTypes.string
  },

  render() {
    return (
      <Modal
        show={this.props.show}
        onHide={this.props.onHide}
        bsSize="large"
      >
        <Modal.Header closeButton>
          <Modal.Title>
            How To Connect
          </Modal.Title>
        </Modal.Header>

        <Modal.Body>
          <div className="row">
            <HowtoTemplates
              componentId={this.props.componentId}
            />
          </div>
        </Modal.Body>

      </Modal>
    );
  }


});
