import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    profile: PropTypes.object.isRequired
  },

  render() {
    const profile = this.props.profile;
    return (
      <span>
        {profile.get('accountName')}/ {profile.get('webPropertyName')}/ {profile.get('name')}
      </span>);
  }
});
