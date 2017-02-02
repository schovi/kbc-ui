import React, {PropTypes} from 'react';
import {Modal, Input} from 'react-bootstrap';
import {Link} from 'react-router';
import RadioGroup from 'react-radio-group';
import MySqlCredentialsContainer from '../components/MySqlCredentialsContainer';
import RedshiftCredentialsContainer from '../components/RedshiftCredentialsContainer';
import SnowflakeCredentialsContainer from '../components/SnowflakeCredentialsContainer';
import ConnectToMySqlSandbox from '../components/ConnectToMySqlSandbox';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';


export default React.createClass({
  propTypes: {
    show: PropTypes.bool.isRequired,
    onHide: PropTypes.func.isRequired,
    mode: PropTypes.string.isRequired,
    backend: PropTypes.string.isRequired,
    progress: PropTypes.string.isRequired,
    progressStatus: PropTypes.string.isRequired,
    isRunning: PropTypes.bool,
    isCreated: PropTypes.bool,
    jobId: PropTypes.string.isRequired,
    mysqlCredentials: PropTypes.object.isRequired,
    redshiftCredentials: PropTypes.object.isRequired,
    snowflakeCredentials: PropTypes.object.isRequired,
    onModeChange: PropTypes.func.isRequired,
    onCreateStart: PropTypes.func.isRequired
  },

  render() {
    return (
      <Modal show={this.props.show} bsSize="large" onHide={this.props.onHide} enforceFocus={false}>
        <Modal.Header closeButton={true}>
          <Modal.Title>Create sandbox</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div>
            <h3>Mode</h3>
            <RadioGroup name="mode" value={this.props.mode} onChange={this.props.onModeChange}>
              <div className="form-horizontal">
                <Input type="radio" label="Load input tables only" wrapperClassName="col-sm-offset-1 col-sm-8" value="input" />
                <Input type="radio" label="Prepare transformation" help="Load input tables AND execute required transformations" wrapperClassName="col-sm-offset-1 col-sm-8" value="prepare" />
                <Input type="radio" label="Execute transformation without writing to Storage" wrapperClassName="col-sm-offset-1 col-sm-8" value="dry-run" />
              </div>
              <div className="help-block">
                Note: Disabled transformations will NOT be executed in any of these modes.
              </div>
            </RadioGroup>
          </div>
          {this.renderCredentials()}
        </Modal.Body>
        <Modal.Footer>
          <div className="pull-left" style={{padding: '6px 12px'}}>
            <span className={'text-' + this.props.progressStatus}>
              {this.renderStatusIcon()} {this.props.progress}
              <span> </span>
              {this.props.jobId ? <Link to="jobDetail" params={{jobId: this.props.jobId}}>More details</Link> : null}
            </span>
          </div>
          <ConfirmButtons
            onCancel={this.props.onHide}
            onSave={this.props.onCreateStart}
            saveLabel={'Create'}
            cancelLabel={'Close'}
            isSaving={this.props.isRunning}
            showSave={!this.props.isCreated}
            isDisabled={!this.hasCredentials()}
            />
        </Modal.Footer>
      </Modal>
    );
  },

  renderStatusIcon() {
    if (this.props.progressStatus === 'success') {
      return (
        <span className="fa fa-check"/>
      );
    } else if (this.props.progressStatus === 'danger') {
      return (
        <span className="fa fa-times"/>
      );
    } else {
      return null;
    }
  },

  hasCredentials() {
    if (this.props.backend === 'mysql') {
      return this.props.mysqlCredentials.has('id');
    } else if (this.props.backend === 'redshift') {
      return this.props.redshiftCredentials.has('id');
    } else if (this.props.backend === 'snowflake') {
      return this.props.snowflakeCredentials.has('id');
    } else {
      return true;
    }
  },

  renderCredentials() {
    if (this.props.backend === 'mysql' || this.props.backend === 'redshift' || this.props.backend === 'snowflake') {
      return (
        <div className="clearfix">
          <h3>Credentials</h3>
          <div className="col-sm-offset-1 col-sm-10">
            {this.props.backend === 'redshift' ? this.renderRedshiftCredentials() : null}
            {this.props.backend === 'mysql' ? this.renderMysqlCredentials() : null}
            {this.props.backend === 'snowflake' ? this.renderSnowflakeCredentials() : null}
          </div>
        </div>
      );
    }
  },

  renderRedshiftCredentials() {
    return React.createElement(RedshiftCredentialsContainer, {
      isAutoLoad: true
    });
  },

  renderSnowflakeCredentials() {
    return (
      <div className="row">
        <div className="col-md-9">
          <SnowflakeCredentialsContainer isAutoLoad={true} />
        </div>
        <div className="col-md-3">
          {this.renderSnowflakeConnect()}
        </div>
      </div>
    );
  },

  renderSnowflakeConnect() {
    if (!this.props.snowflakeCredentials.get('id')) {
      return null;
    }
    return (
      <div>
        <a href={'https://' + this.props.snowflakeCredentials.get('hostname') + '/console'} target="_blank" className="btn btn-link">
          <span className="fa fa-fw fa-database" />
          <span> Connect</span>
        </a>
      </div>
    );
  },

  renderMysqlCredentials() {
    return (
      <div className="row">
        <div className="col-md-9">
          <MySqlCredentialsContainer isAutoLoad={true} />
        </div>
        <div className="col-md-3">
          {this.renderMysqlConnect()}
        </div>
      </div>
    );
  },

  renderMysqlConnect() {
    if (!this.props.mysqlCredentials.get('id')) {
      return null;
    }
    return (
      <ConnectToMySqlSandbox credentials={this.props.mysqlCredentials}>
        <button className="btn btn-link" title="Connect to Sandbox" type="submit">
          <span className="fa fa-fw fa-database"/> Connect
        </button>
      </ConnectToMySqlSandbox>
    );
  }

});
