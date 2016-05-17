import React from 'react';
import Remarkable from 'react-remarkable';

require('./Markdown.less');

export default React.createClass({
  propTypes: {
    source: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      source: ''
    };
  },

  render() {
    return (
      <span className="kbc-markdown">
        <Remarkable source={this.props.source} />
      </span>
    );
  }
});
