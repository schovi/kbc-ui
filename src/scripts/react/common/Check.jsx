import React from 'react';

export default React.createClass({
  propTypes: {
    isChecked: React.PropTypes.bool.isRequired
  },

  render() {
    return (
      <i className={this.props.isChecked ? 'fa fa-fw fa-check' : 'fa fa-fw fa-times'}/>
    );
  }
});
