/* eslint react/no-did-mount-set-state: 0 */

import React from 'react';

require('./ReadMore.less');

export default React.createClass({
  propTypes: {
    height: React.PropTypes.string,
    children: React.PropTypes.node
  },

  getDefaultProps() {
    return {
      height: 'normal'
    };
  },

  getInitialState() {
    return {
      expanded: false,
      showExpandButton: true
    };
  },

  componentDidMount() {
    var height = this.refs.container.getDOMNode().offsetHeight;
    if (this.props.height === 'normal' && height < 250) {
      this.setState({showExpandButton: false});
    } else {
      this.setState({showExpandButton: true});
    }
  },

  render() {
    return (
      <div className={'kbc-readmore ' + this.readmoreClass()} ref="container">
        {this.props.children}
        {this.expandButton()}
      </div>
    );
  },

  expandButton() {
    if (!this.state.showExpandButton) {
      return null;
    }
    if (this.state.expanded) {
      return (<div className="kbc-readmore-collapse"><a className="button" onClick={this.onClick}>Less...</a></div>);
    } else {
      return (<div className="kbc-readmore-expand"><a className="button" onClick={this.onClick}>More...</a></div>);
    }
  },

  onClick() {
    this.setState({expanded: !this.state.expanded});
  },

  readmoreClass() {
    if (this.state.expanded) {
      return '';
    } else {
      return 'kbc-readmore-' + this.props.height;
    }
  }

});
