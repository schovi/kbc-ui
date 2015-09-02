import React from 'react';

/**
 * Creates components with set of props
 * @param props
 * @returns {Function}
 */
export default function (props) {
  return InnerComponent => React.createClass({
    render() {
      return (
        <InnerComponent {...props} />
      );
    }
  });
}