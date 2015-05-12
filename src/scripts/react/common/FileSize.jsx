import React from 'react';
import filesize from 'filesize';

export default React.createClass({
  propTypes: {
    size: React.PropTypes.number
  },

  render() {
    return this.props.size ? filesize(this.props.size) : 'N/A';
  }

});