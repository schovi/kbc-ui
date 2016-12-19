import React from 'react';

function convertToCredits(nanoCredits) {
  return Number((nanoCredits / (1000 * 1000 * 1000)).toFixed(3));
}

export default React.createClass({
  propTypes: {
    nanoCredits: React.PropTypes.number
  },

  render() {
    return (
      <span>
        {
          this.props.nanoCredits
            ? convertToCredits(this.props.nanoCredits) + ' credits'
            : 'N/A'
        }
      </span>
    );
  }

});
