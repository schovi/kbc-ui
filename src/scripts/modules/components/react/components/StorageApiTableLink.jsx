import React from 'react';

import ApplicationStore from '../../../../stores/ApplicationStore';


export default React.createClass({
  propTypes: {
    tableId: React.PropTypes.string.isRequired,
    children: React.PropTypes.any
  },

  tableUrl() {
    return ApplicationStore.getSapiTableUrl(this.props.tableId);
  },

  render() {
    return (
      <a
         target="_blank"
         href={this.tableUrl()}>{this.props.children}</a>
    );
  }

});
