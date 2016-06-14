
import React from 'react';
import MySqlSandbox from '../../components/MySqlSandbox';
import RedshiftSandbox from '../../components/RedshiftSandbox';
import SnowflakeSandbox from '../../components/SnowflakeSandbox';

export default React.createClass({
  displayName: 'Sandbox',
  render: function() {
    return (
      <div className="container-fluid">
        <div className="col-md-12 kbc-main-content">
          <MySqlSandbox />
          <RedshiftSandbox />
          <SnowflakeSandbox />
        </div>
      </div>
    );
  }
});
