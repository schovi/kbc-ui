import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    queries: PropTypes.object.isRequired,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired
  },

  render() {
    return (
      <div>
        QueriesTable
      </div>
    );
  }

});
