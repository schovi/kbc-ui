import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    allProfiles: PropTypes.object.isRequired,
    selectedProfiles: PropTypes.object.isRequired
  },

  getProfile() {
    return this.props.allProfiles.find((p) => p.get('id').toString() === this.props.selectedProfiles.toString());
  },

  render() {
    const profile = this.getProfile();
    if (!this.props.selectedProfiles) {
      return <span> --all profiles--</span>;
    }
    if (!profile) {
      return (
        <span>
          Unknown({this.props.selectedProfiles})
        </span>
      );
    } else {
      return (
        <span>
          <small>{profile.get('accountName')}/ </small>
          <small>{profile.get('webPropertyName')}/ </small>
          <small>{profile.get('name')}</small>
        </span>
      );
    }
  }
});
