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
      expanded: false
    };
  },

  render() {
    return (
      <div className={'kbc-readmore ' + this.readmoreClass()}>
        {this.props.children}
        {this.expandButton()}
      </div>
    );
  },

  expandButton() {
    console.log(this.state, this.state.expanded);
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
