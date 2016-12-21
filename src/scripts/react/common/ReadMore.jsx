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
    if (this.props.height === 'normal' && height < 150 || this.props.height === 'small' && height < 100) {
      this.setState({showExpandButton: false});
    } else {
      this.setState({showExpandButton: true});
    }
  },

  render() {
    return (
      <div>
        <div className={'kbc-readmore ' + this.readmoreClass()} ref="container">
          {this.props.children}
          {this.gradient()}
        </div>
        {this.button()}
      </div>
    );
  },

  gradient() {
    const { expanded, showExpandButton } = this.state;

    if (expanded || !showExpandButton) {
      return null;
    }

    return <div className="kbc-readmore-fadeout" />;
  },

  button() {
    if (!this.state.showExpandButton) {
      return null;
    }
    if (this.state.expanded) {
      return (<div className="kbc-readmore-button"><a className="button" onClick={this.onClick}>Show less</a></div>);
    } else {
      return (<div className="kbc-readmore-button"><a className="button" onClick={this.onClick}>Show more</a></div>);
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
