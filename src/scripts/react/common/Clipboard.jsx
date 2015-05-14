import React from 'react';
import ReactZeroClipboard from 'react-zeroclipboard';

export default React.createClass({
  propTypes: {
    text: React.PropTypes.string.isRequired
  },

  render() {
    return (
      <ReactZeroClipboard getText={this.props.text}>
        <span className="fa fa-fw fa-copy" />
      </ReactZeroClipboard>
    );
  }

});