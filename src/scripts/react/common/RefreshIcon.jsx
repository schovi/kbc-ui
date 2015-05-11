import React from 'react';
import Loader from './Loader';

export default  React.createClass({
  propTypes: {
    isLoading: React.PropTypes.bool.isRequired,
    title: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      title: 'Refresh'
    };
  },

  render() {
    return (
        <span title={this.props.title}>
          <span {...this.props} className="kbc-refresh kbc-icon-cw"></span> {this.loader()}
        </span>
    );
  },

  loader() {
    if (this.props.isLoading) {
      return (<Loader/>);
    } else {
      return false;
    }
  }

});
