import React, {PropTypes} from 'react';
import {Input} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    allProfiles: PropTypes.object.isRequired,
    selectedProfile: PropTypes.string.isRequired,
    labelClassName: PropTypes.string,
    wrapperClassName: PropTypes.string,
    label: PropTypes.string,
    onSelectProfile: PropTypes.func.isRequired
  },

  getDefaultProps() {
    return {
      labelClassName: 'col-xs-2',
      wrapperClassName: 'col-xs-8',
      label: 'Profiles'
    };
  },

  render() {
    return (
      <Input
        type="select"
        value={this.props.selectedProfile}
        label={this.props.label}
        labelClassName={this.props.labelClassName}
        wrapperClassName={this.props.wrapperClassName}
        onChange={this.onSelect}>

        <option value="">
          --all--
        </option>

        {this.renderOptionsArray()}
      </Input>
    );
  },

  renderOptionsArray() {
    const groups = this.props.allProfiles.groupBy( (profile) =>
      profile.get('accountName') + '/ ' + profile.get('webPropertyName'));
    const options = groups.map((group, groupName) =>
      <optgroup label={groupName}>
        {group.map((item) =>
          <option value={item.get('id')}>
            {item.get('name')}
          </option>
         )}
      </optgroup>
    );


    return options;
  },

  onSelect(event) {
    const value = event.target.value;
    this.props.onSelectProfile(value);
  }
});
