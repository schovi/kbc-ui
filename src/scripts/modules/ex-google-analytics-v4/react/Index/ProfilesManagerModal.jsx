import React, {PropTypes} from 'react';
import {Modal} from 'react-bootstrap';
import ProfileInfo from '../ProfileInfo';
// import ConfirmButtons from '../../../../react/common/ConfirmButtons';

import ProfilesLoader from '../../../google-utils/react/ProfilesPicker';
import ApplicationActionCreators from '../../../../actions/ApplicationActionCreators';

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
          {this.renderProfilesLoader()}
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

  renderProfilesLoader() {
    return (
      <div className="text-center">
        <ProfilesLoader
          email={null}
          onProfilesLoadError={(err) => {
            ApplicationActionCreators.sendNotification({
              message: err.message,
              type: 'error'
            });
          }}
          onProfilesLoad={(profiles, email) => {
            console.log('loaded profiles', profiles, email);
          }}
        />
      </div>
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
