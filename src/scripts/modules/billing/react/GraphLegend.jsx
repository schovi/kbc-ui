import React, {PropTypes}  from 'react';
import CreditSize from '../../../react/common/CreditSize';

export default React.createClass({

  propTypes: {
    title: PropTypes.string.isRequired,
    value: PropTypes.number.isRequired
  },

  render: function() {
    return (
      <div className="text-center">
        <h3>Storage IO</h3>
        <h4>
          Consumed <CreditSize nanoCredits={this.props.value}/>
        </h4>
      </div>
    );
  }

});
