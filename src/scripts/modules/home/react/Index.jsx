import React from 'react';
import ApplicationStore from '../../../stores/ApplicationStore';
import filesize from 'filesize';
import string from 'underscore.string';

export default React.createClass({

  getInitialState() {
    const currentProject = ApplicationStore.getCurrentProject(),
      tokenStats = ApplicationStore.getTokenStats();
    return {
      data: {
        sizeBytes: currentProject.get('dataSizeBytes'),
        rowsCount: currentProject.get('rowsCount')
      },
      tokens: tokenStats
    };
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        <div className="table kbc-table-border-vertical kbc-layout-table kbc-overview">
          <div className="tbody">
            <div className="tr">
              <div className="td">
                <h2>Storage</h2>
                <h3 style={ {fontSize: '64px'} }>{filesize(this.state.data.sizeBytes)}</h3>
                <h3 style={ {fontSize: '34px'} }>{string.numberFormat(this.state.data.rowsCount)} <small>Rows</small></h3>
              </div>
              <div className="td">
                <h2>Access</h2>
                <h3 style={ {fontSize: '64px'} }>{this.state.tokens.get('adminCount')} <small style={ {fontSize: '24px'} }>Admins</small></h3>
                <h3 style={ {fontSize: '34px'} }>{this.state.tokens.get('totalCount') - this.state.tokens.get('adminCount')} <small>API Tokens</small></h3>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
