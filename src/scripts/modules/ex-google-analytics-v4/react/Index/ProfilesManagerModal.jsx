import React, {PropTypes} from 'react';
import {Modal} from 'react-bootstrap';
import ProfileInfo from '../ProfileInfo';
// import ConfirmButtons from '../../../../react/common/ConfirmButtons';
export default React.createClass({

  propTypes: {
    profiles: PropTypes.object.isRequired,
    show: PropTypes.bool.isRequired,
    onHideFn: PropTypes.func
  },

  render() {
    return (
      <Modal
        bsSize="large"
        show={this.props.show}
        onHide={this.props.onHideFn}
      >
        <Modal.Header closeButton>
          <Modal.Title>
            Setup Profiles
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {this.renderProfiles()}
        </Modal.Body>
        <Modal.Footer>
          {/* <ConfirmButtons
          isSaving={this.props.isSaving}
          onSave={this.handleSave}
          onCancel={this.props.onCancel}
          placement="right"
          saveLabel={this.props.saveLabel}
          isDisabled={!this.props.isValid}
          /> */}

        </Modal.Footer>
      </Modal>
    );
  },

  renderProfiles() {
    return (
      <div>
        {this.props.profiles.map( (profile) =>
          <ProfileInfo profile={profile} />
         )}
      </div>
    );
  }
});
