import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    profile: PropTypes.object.isRequired
  },

  render() {
    const profile = this.props.profile;
    return (
      <span>
        <small>{profile.get('accountName')}/ </small>
        <small>{profile.get('webPropertyName')}/ </small>
        <small>{profile.get('name')}</small>
      </span>
    );
  }
});
