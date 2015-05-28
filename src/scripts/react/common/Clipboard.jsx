import React from 'react';
import ReactZeroClipboard from 'react-zeroclipboard';
import {Tooltip, OverlayTrigger} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    text: React.PropTypes.string.isRequired
  },

  getInitialState() {
    return {
      isCopied: false
    };
  },

  render() {
    return (
      <OverlayTrigger overlay={this.tooltip()} ref="overlay">
        <span>
          <ReactZeroClipboard getText={this.props.text} onAfterCopy={this.handleAfterCopy}>
            <span className="fa fa-fw fa-copy" />
          </ReactZeroClipboard>
        </span>
      </OverlayTrigger>
    );
  },

  tooltip() {
    return (
      <Tooltip>{this.state.isCopied ? 'Copied!' : 'Copy to clipboard'}</Tooltip>
    );
  },

  handleAfterCopy() {
    this.setState({
      isCopied: true
    });
    this.refs.overlay.show();
    /*global setTimeout*/
    setTimeout(this.hideOverlay, 300);
  },

  hideOverlay() {
    this.refs.overlay.hide();
    this.setState({
      isCopied: false
    });
  }

});