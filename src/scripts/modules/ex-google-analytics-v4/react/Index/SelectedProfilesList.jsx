import React, {PropTypes} from 'react';
import ProfileInfo from '../ProfileInfo';
export default React.createClass({
  propTypes: {
    allProfiles: PropTypes.object.isRequired,
    profileIds: PropTypes.object
  },

  getProfile(profileId) {
    return this.props.allProfiles.find((p) => p.get('id').toString() === profileId.toString());
  },

  render() {
    if (!this.props.profileIds) {
      return <span>--all profiles--</span>;
    }

    return (
      <span>
        {this.props.profileIds.map((profileId) => this.renderProfile(profileId))}
      </span>
    );
  },

  renderProfile(profileId) {
    const profile = this.getProfile(profileId);
    if (!profile) {
      return (
        <span>
          Unknown Profile({profileId})
        </span>
      );
    } else {
      return (
        <small>
          <ProfileInfo profile={profile} />
        </small>
      );
    }
  }
});
