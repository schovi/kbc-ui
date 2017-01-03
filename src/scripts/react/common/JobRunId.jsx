import React from 'react';

export default React.createClass({

  propTypes: {
    runId: React.PropTypes.string
  },

  render() {
    return (
      <strong style={{wordBreak: 'break-all'}}>
        {this.props.runId}
      </strong>
    );
  }

});
