import React from 'react';

/**
 * Creates components with set of props
 * @param {Object} props Properties
 * @returns {Function} React Component
 */
export default function(props) {
  return InnerComponent => React.createClass({
    render() {
      return (
        <InnerComponent {...props} />
      );
    }
  });
}