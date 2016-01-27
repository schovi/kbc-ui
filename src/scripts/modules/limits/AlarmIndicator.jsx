import React from 'react';
import classnames from 'classnames';

export default React.createClass({
  propTypes: {
    isAlarm: React.PropTypes.bool.isRequired
  },

  render() {
    return (
      <span className={classnames('fa', {'fa-check-circle-o': !this.props.isAlarm, 'fa-exclamation-circle ': this.props.isAlarm})} style={this.style()}></span>
    );
  },

  style() {
    return {
      fontSize: '20px',
      color: this.props.isAlarm ? '#a94442' : '#3c763d'
    };
  }
});