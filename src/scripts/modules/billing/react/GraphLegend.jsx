import React, {PropTypes}  from 'react';
import {getConversion} from './Graph';

export default React.createClass({

  propTypes: {
    title: PropTypes.string.isRequired,
    value: PropTypes.number.isRequired
  },

  render: function() {
    const conversion = getConversion('bytes');
    return (
      <div className="text-center">
        <h3>Storage IO</h3>
        <h4>Consumed {conversion(this.props.value)} GB</h4>
      </div>
    );
  }

});
