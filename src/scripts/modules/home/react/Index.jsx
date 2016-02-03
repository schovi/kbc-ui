import React from 'react';
import ApplicationStore from '../../../stores/ApplicationStore';
import filesize from 'filesize';
import string from 'underscore.string';
import LimitsOverQuota from './LimitsOverQuota';

export default React.createClass({

  getInitialState() {
    const currentProject = ApplicationStore.getCurrentProject(),
      tokenStats = ApplicationStore.getTokenStats();
    return {
      data: {
        sizeBytes: currentProject.get('dataSizeBytes'),
        rowsCount: currentProject.get('rowsCount')
      },
      tokens: tokenStats,
      projectId: currentProject.get('id'),
      limitsOverQuota: ApplicationStore.getLimitsOverQuota()
    };
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        {ApplicationStore.hasCurrentAdminFeature('kbc-notifications') ?
          <LimitsOverQuota limits={this.state.limitsOverQuota}/> :
          null
        }
        <div className="table kbc-table-border-vertical kbc-layout-table kbc-overview">
          <div className="tbody">
            <div className="tr">
              <div className="td">
                <h2>Storage</h2>
                <h3 style={ {fontSize: '42px'} }>{filesize(this.state.data.sizeBytes)}</h3>
                <h3 style={ {fontSize: '24px'} }>{string.numberFormat(this.state.data.rowsCount)} <small>Rows</small></h3>
              </div>
              <div className="td">
                <h2>Access</h2>
                <h3 style={ {fontSize: '42px'} }>{this.state.tokens.get('adminCount')} <small style={ {fontSize: '16px'} }>Admins</small></h3>
                <h3 style={ {fontSize: '24px'} }>{this.state.tokens.get('totalCount') - this.state.tokens.get('adminCount')} <small>API Tokens</small></h3>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
