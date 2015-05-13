import React from 'react';

import ApplicationStore from '../../../../stores/ApplicationStore';


export default React.createClass({
  propTypes: {
    tableId: React.PropTypes.string.isRequired,
    children: React.PropTypes.any
  },

  tableUrl() {
    return ApplicationStore.getProjectBaseUrl() + `/storage#/tables/${this.props.tableId}`;
  },

  render() {
    return (
      <a href={this.tableUrl()}>{this.props.children}</a>
    );
  }

});