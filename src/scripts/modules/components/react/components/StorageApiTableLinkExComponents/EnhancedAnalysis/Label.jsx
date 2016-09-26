import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    caption: PropTypes.string.isRequired
  },

  render() {
    return (
      <span className="label label-info">{this.propTypes.caption}</span>
    );
  }
});
