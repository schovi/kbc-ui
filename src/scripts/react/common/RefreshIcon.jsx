import React from 'react';
import Loader from './Loader';

const LEFT = 'left', RIGHT = 'right';

export default  React.createClass({
  propTypes: {
    isLoading: React.PropTypes.bool.isRequired,
    title: React.PropTypes.string,
    loaderPosition: React.PropTypes.oneOf([LEFT, RIGHT])
  },

  getDefaultProps() {
    return {
      title: 'Refresh',
      loaderPosition: RIGHT
    };
  },

  render() {
    return (
        <span title={this.props.title}>
          {this.loaderLeft()}  <span {...this.props} className="kbc-refresh kbc-icon-cw"></span> {this.loaderRight()}
        </span>
    );
  },

  loaderLeft() {
    if (this.props.loaderPosition == LEFT) {
      return this.loader();
    }
  },

  loaderRight() {
    if (this.props.loaderPosition == RIGHT) {
      return this.loader();
    }
  },

  loader() {
    if (this.props.isLoading) {
      return (<Loader/>);
    }
  }

});
