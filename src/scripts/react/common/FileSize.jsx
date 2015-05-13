import React from 'react';
import fileSize from 'filesize';

export default React.createClass({
  propTypes: {
    size: React.PropTypes.number
  },

  render() {
    return (
        <span>
          {this.props.size ? fileSize(this.props.size) : 'N/A'}
        </span>
    );
  }

});