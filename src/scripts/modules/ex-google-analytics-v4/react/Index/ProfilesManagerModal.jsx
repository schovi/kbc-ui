import React, {PropTypes} from 'react';
import {List, Map, fromJS} from 'immutable';
import {Modal, Alert, Panel, ListGroup, ListGroupItem} from 'react-bootstrap';
import ProfileInfo from '../ProfileInfo';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';

import ProfilesLoader from '../../../google-utils/react/ProfilesPicker';
import ApplicationActionCreators from '../../../../actions/ApplicationActionCreators';
import EmptyState from '../../../components/react/components/ComponentEmptyState';

import './ProfilesManagerModal.less';

export default React.createClass({

  propTypes: {
    profiles: PropTypes.object.isRequired,
    show: PropTypes.bool.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onHideFn: PropTypes.func,
    authorizedEmail: PropTypes.string,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired,
    onSaveProfiles: PropTypes.func.isRequired

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
          <ConfirmButtons
            isSaving={this.props.isSaving}
            onSave={this.handleSave}
            onCancel={this.props.onHideFn}
            placement="right"
            saveLabel="Save Changes"
            isDisabled={!this.isProfilesChanged()}
          />

        </Modal.Footer>
      </Modal>
    );
  },

  handleSave() {
    this.props.onSaveProfiles(this.getLocalProfiles()).then(
      () => this.props.onHideFn()
    );
  },

  isProfilesChanged() {
    const oldSet = this.props.profiles.map((p) => (p.get('id').toString())).toSet();
    const newSet = this.getLocalProfiles().map((p) => (p.get('id').toString())).toSet();
    return newSet.count() > 0 && oldSet.hashCode() !== newSet.hashCode();
  },

  renderProjectProfiles() {
    const profiles = this.getLocalProfiles();
    return (
      <div>
        <h3> Selected Profiles To Extract Data from {this.props.authorizedEmail}</h3>

        {profiles.count() > 0 ?
         <ul>
           {profiles.map( (profile) =>
             <li>
               <ProfileInfo profile={profile} />
               <span onClick={() => this.deselectProfile(profile.get('id'))}className="kbc-icon-cup kbc-cursor-pointer" />

             </li>
            )}
         </ul>
         :
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
        <h3> 1. Load Google Account Profiles</h3>
        {this.renderProfilesPicker()}
        {profiles ?
         <span>
           <h3>2. Select Profiles of {email} </h3>
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
        {profileGroupName}
      </span>);

    return (
      <Panel
        header={header}
        key={profileGroupName}
        collapsible={true}
        className="profile-panel">
        {profileGroup.map((p, pname) => this.renderProfilePanel(p, pname))}
      </Panel>
    );
  },

  renderProfilePanel(profile, profileName) {
    const header = (
      <span>
        {profileName}
      </span>);
    return (
      <Panel
        header={header}
        key={profileName}
        eventKey={profileName}
        collapsible={true}>
        <div className="row">
          <ListGroup>
            {profile.map((pItem) =>
              <ListGroupItem
                active={this.isSelected(pItem)}
                onClick={() => this.onProfileClick(pItem)}>
                <div className="text-center">
                  {pItem.get('name')}
                </div>
              </ListGroupItem>).toArray()}
          </ListGroup>
        </div>
      </Panel>
    );
  },

  getLocalProfiles() {
    return this.props.localState.get('profiles', List());
  },

  onProfileClick(profile) {
    const profiles = this.getLocalProfiles();
    if (!this.isSelected(profile)) {
      this.props.updateLocalState('profiles', profiles.push(profile));
    } else {
      this.deselectProfile(profile.get('id'));
    }
  },

  isSelected(profile) {
    const profiles = this.props.localState.get('profiles', List());
    return profiles.find((p) => p.get('id').toString() === profile.get('id').toString());
  },

  deselectProfile(profileId) {
    const profiles = this.getLocalProfiles();
    const newProfiles = profiles.filter((p) => p.get('id') !== profileId);
    this.props.updateLocalState('profiles', newProfiles);
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
