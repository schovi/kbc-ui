import React, {PropTypes} from 'react';
import {Map, fromJS} from 'immutable';
import {Modal, Alert, Panel, ListGroup, ListGroupItem} from 'react-bootstrap';
import ProfileInfo from '../ProfileInfo';
// import ConfirmButtons from '../../../../react/common/ConfirmButtons';

import ProfilesLoader from '../../../google-utils/react/ProfilesPicker';
import ApplicationActionCreators from '../../../../actions/ApplicationActionCreators';
import EmptyState from '../../../components/react/components/ComponentEmptyState';

export default React.createClass({

  propTypes: {
    profiles: PropTypes.object.isRequired,
    show: PropTypes.bool.isRequired,
    onHideFn: PropTypes.func,
    authorizedEmail: PropTypes.string,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired

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
          <div className="row">
            <div className="table kbc-table-border-vertical kbc-detail-table">
              <div className="tr">
                <div className="td">
                  {this.renderProfilesSelector()}
                </div>
                <div className="td">
                  {this.renderProjectProfiles()}
                </div>
              </div>
            </div>
          </div>
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

  renderProjectProfiles() {
    return (
      <div>
        <h2> Selected Profiles To Extract Data from {this.props.authorizedEmail}</h2>

        {this.props.profiles.count() > 0 ?
         this.props.profiles.map( (profile) =>
           <ProfileInfo profile={profile} />
         ) :
         <EmptyState>
           No profiles selected.
         </EmptyState>
        }
      </div>
    );
  },

  renderProfilesSelector() {
    const gaData = this.props.localState.get('gaPickerData', Map());
    const profiles = gaData.get('profiles');
    const email = gaData.get('email');
    return (
      <div className="text-center">
        <h2> 1. Load Google Account Profiles</h2>
        {this.renderProfilesPicker()}
        {profiles ?
         <span>
           <h2>2. Select Profiles of {email} </h2>
           {this.renderWarning(email)}
           {this.renderLoadedProfiles(profiles)}
         </span>
         :
         <EmptyState>
           No Profiles Loaded
         </EmptyState>
        }
      </div>
    );
  },


  renderWarning(profilesEmail) {
    const {authorizedEmail} = this.props;
    if (authorizedEmail && profilesEmail && profilesEmail !== authorizedEmail) {
      return (
        <Alert bsStyle="warning">
          <strong>Warning:</strong>
          Selected account {profilesEmail} does not match account authorized for data extraction <strong>{authorizedEmail}</strong>.
        </Alert>
      );
    } else {
      return null;
    }
  },

  renderLoadedProfiles(profiles) {
    return (
      <div className="kbc-accordion kbc-panel-heading-with-table kbc-panel-heading-with-table'">
        { profiles && profiles.count() > 0 ?
          profiles.map((p, pname) => this.renderProfileGroup(p, pname))
          :
          <EmptyState>The account has no profiles</EmptyState>
        }
      </div>
    );
  },


  renderProfileGroup(profileGroup, profileGroupName) {
    const header = (
    <span>
      <span className="table" style={{margin: '0'}}>
        <span className="tbody">
          <span className="tr">
            <span className="td">
              {profileGroupName}
            </span>
          </span>
        </span>
      </span>
    </span>);

    return (
      <Panel
        header={header}
        key={profileGroupName}
        collapsible={true}
        className="profile-name">
        {profileGroup.map((p, pname) => this.renderProfilePanel(p, pname))}
      </Panel>
    );
  },

  renderProfilePanel(profile, profileName) {
    const header = (
    <span>
      <span className="table" style={{margin: '0'}}>
        <span className="tbody">
          <span className="tr">
            <span className="td">
              {profileName}
            </span>
          </span>
        </span>
      </span>
    </span>);
    return (
      <div className="kbc-accordion kbc-panel-heading-with-table kbc-panel-heading-with-table">
        <Panel
          header={header}
          key={profileName}
          eventKey={profileName}
          collapsible={true}>
          <div className="row">
            <ListGroup props={{}}>
              {profile.map((pItem) =>
                <ListGroupItem>
                  {pItem.get('name')}
                </ListGroupItem>).toArray()}
            </ListGroup>
          </div>
        </Panel>
      </div>
    );
  },

  renderProfilesPicker() {
    return (
      <ProfilesLoader
        email={null}
        onProfilesLoadError={
          (err) => {
            ApplicationActionCreators.sendNotification({
              message: err.message,
              type: 'error'
            });
          }}
        onProfilesLoad={
          (profiles, email) => {
            const pickerData = fromJS({
              profiles: profiles,
              email: email
            });
            this.props.updateLocalState('gaPickerData', pickerData);
            console.log('loaded profiles', profiles, email);
          }}
      />
    );
  }
});
