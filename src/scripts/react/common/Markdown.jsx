import React from 'react';
import Remarkable from 'react-remarkable';
import ReadMore from './ReadMore';

require('./Markdown.less');

export default React.createClass({
  propTypes: {
    source: React.PropTypes.string,
    height: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      source: '',
      height: 'normal'
    };
  },

  render() {
    return (
      <span className="kbc-markdown">
        <ReadMore height={this.props.height}>
          <Remarkable source={this.props.source} />
        </ReadMore>
      </span>
    );
  }
});
