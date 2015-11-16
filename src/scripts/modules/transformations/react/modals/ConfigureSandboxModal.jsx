import React, {PropTypes} from 'react';
import {Modal, Input} from 'react-bootstrap';
import {Link} from 'react-router';
import RadioGroup from 'react-radio-group';
import MySqlCredentialsContainer from '../components/MySqlCredentialsContainer';
import RedshiftCredentialsContainer from '../components/RedshiftCredentialsContainer';
import ConnectToMySqlSandbox from '../components/ConnectToMySqlSandbox';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';

function renderStatusIcon(status) {
  switch (status) {
    case 'success':
      return <span className="fa fa-check"/>;
    case 'danger':
      return <span className="fa fa-times"/>;
    default:
      return null;
  }
}

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
    onModeChange: PropTypes.func.isRequired,
    onCreateStart: PropTypes.func.isRequired
  },

  render() {
    return (
      <Modal show={this.props.show} bsSize="large" onHide={this.props.onHide}>
        <Modal.Header closeButton={true}>
          <Modal.Title>Create Sandbox</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div>
            <h3>Mode</h3>
            <RadioGroup name="mode" value={this.props.mode} onChange={this.props.onModeChange}>
              <div className="form-horizontal">
                <Input type="radio" label="Load input tables only" wrapperClassName="col-sm-offset-1 col-sm-8" value="input" />
                <Input type="radio" label="Prepare transformation" help="Load input tables AND perform required transformations" wrapperClassName="col-sm-offset-1 col-sm-8" value="prepare" />
                <Input type="radio" label="Execute transformation without writing to Storage API" wrapperClassName="col-sm-offset-1 col-sm-8" value="dry-run" />
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
              {renderStatusIcon(this.props.progressStatus)} {this.props.progress}
              {this.props.jobId ? <Link to="jobDetail" params={{jobId: this.props.jobId}} > More details</Link> : null}
            </span>
          </div>
          <ConfirmButtons
            onCancel={this.props.onHide}
            onSave={this.props.onCreateStart}
            saveLabel={'Create'}
            cancelLabel={'Close'}
            isSaving={this.props.isRunning}
            showSave={!this.props.isCreated}
            />
        </Modal.Footer>
      </Modal>
    );
  },

  renderCredentials() {
    if (this.props.backend === 'mysql' || this.props.backend === 'redshift') {
      return (
        <div className="clearfix">
          <h3>Credentials</h3>
          <div className="col-sm-offset-1 col-sm-10">
            {this.props.backend === 'redshift' ? this.renderRedshiftCredentials() : this.renderMysqlCredentials()}
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
