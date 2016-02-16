import React from 'react';

export default React.createClass({

  getInitialState() {
    return {isExpanded: false};
  },

  render() {
    if (this.state.isExpanded) {
      return (
        <span>
          {this.renderInfo()}
          <button
            onClick={ () => this.setState({isExpanded: false})}
            className="btn btn-sm btn-link">
            Hide
          </button>
        </span>
      );
    } else {
      return (
        <span>
          <button
            onClick={ () => this.setState({isExpanded: true})}
            className="btn btn-sm btn-link">
            More about phases
          </button>
        </span>

      );
    }
  },

  renderInfo() {
    return (
      <span>
        Phases are executed sequentially. All tasks within a phase are run in parallel. The next phase begins right after all task within the previous phase are finished.
      </span>
    );
  }

});
