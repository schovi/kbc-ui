
import React from 'react';
import MySqlSandbox from '../../components/MySqlSandbox';
import RedshiftSandbox from '../../components/RedshiftSandbox';
import SnowflakeSandbox from '../../components/SnowflakeSandbox';
import RStudioSandbox from '../../components/RStudioSandbox';
import ApplicationStore from '../../../../../stores/ApplicationStore';
import Immutable from 'immutable';

export default React.createClass({
  displayName: 'Sandbox',
  render: function() {
    return (
      <div className="container-fluid">
        <div className="col-md-12 kbc-main-content">
          <MySqlSandbox />
          {ApplicationStore.getSapiToken().getIn(['owner', 'hasRedshift'], false) ? (<RedshiftSandbox />) : null}
          {ApplicationStore.getSapiToken().getIn(['owner', 'hasSnowflake'], false) ? (<SnowflakeSandbox />) : null}
          {ApplicationStore.getSapiToken().getIn(['admin', 'features'], Immutable.List()).includes('docker-sandbox') ? (<RStudioSandbox />) : null}
        </div>
      </div>
    );
  }
});
