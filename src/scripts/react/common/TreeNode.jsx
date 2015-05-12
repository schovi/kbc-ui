import React from 'react';
import Immutable from 'immutable';

const TreeNode = React.createClass({
  propTypes: {
    data: React.PropTypes.object.isRequired
  },

  render() {
    return (
        <ul>
          {this.props.data.map(this.renderRow, this)}
        </ul>
    );
  },

  renderRow(value, key) {
    return (
      <li>
        {Immutable.Iterable.isIterable(value) ? this.renderNode(value, key) : this.renderLeaf(value, key)}
      </li>
    );
  },

  renderNode(value, key) {
    return (
      <span>
          <strong>{key}</strong>
          <TreeNode data={value}/>
      </span>
    );
  },

  renderLeaf(value, key) {
    return (
        <span>
          <strong>{key}</strong>: {value}
        </span>
    );
  }

});

export default TreeNode;