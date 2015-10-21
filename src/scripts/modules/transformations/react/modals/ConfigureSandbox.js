import React, {PropTypes} from 'react';
import ConfigureSandboxModal from './ConfigureSandboxModal';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import MySqlSandboxCredentialsStore from '../../../provisioning/stores/MySqlSandboxCredentialsStore';
import jobsApi from '../../../jobs/JobsApi';
import actionCreators from '../../../components/InstalledComponentsActionCreators';


export default React.createClass({
  propTypes: {
    show: PropTypes.bool.isRequired,
    onHide: PropTypes.func.isRequired,
    defaultMode: PropTypes.string.isRequired,
    backend: PropTypes.string.isRequired,
    runParams: PropTypes.object.isRequired
  },
  mixins: [createStoreMixin(MySqlSandboxCredentialsStore)],

  getStateFromStores() {
    return {
      mysqlCredentials: MySqlSandboxCredentialsStore.getCredentials()
    };
  },

  getInitialState() {
    return {
      mode: this.props.defaultMode,
      isRunning: false,
      jobId: null,
      progress: null,
      progressStatus: null
    };
  },

  render() {
    return React.createElement(ConfigureSandboxModal, {
      mysqlCredentials: this.state.mysqlCredentials,
      onHide: this.handleModalClose,
      show: this.props.show,
      backend: this.props.backend,
      mode: this.state.mode,
      jobId: this.state.jobId,
      progress: this.state.progress,
      progressStatus: this.state.progressStatus,
      isRunning: this.state.isRunning,
      onModeChange: this.handleModeChange,
      onCreateStart: this.handleSandboxCreate
    });
  },

  handleModeChange(e) {
    this.setState({
      mode: e.target.value
    });
  },

  handleSandboxCreate() {
    this.setState({
      isRunning: true,
      jobId: null,
      progress: 'Waiting for load start ...',
      progressStatus: null
    });
    actionCreators.runComponent({
      component: 'transformation',
      notify: false,
      data: this.props.runParams.set('mode', this.state.mode).toJS()
    }).then(this.handleJobReceive).catch((e) => {
      this.setState({
        isRunning: false
      });
      throw e;
    });
  },

  handleJobReceive(job) {
    if (!this.isMounted()) {
      return;
    }
    if (job.isFinished) {
      if (job.status === 'success') {
        this.setState({
          isRunning: false,
          progress: 'Sandbox is successfully loaded. You can start using it now!',
          progressStatus: 'success',
          jobId: null
        });
      } else {
        this.setState({
          isRunning: false,
          progress: 'Load finished with error.',
          progressStatus: 'danger',
          jobId: job.id
        });
      }
    } else {
      this.setState({
        jobId: job.id,
        progress: job.state === 'waiting' ? 'Waiting for load start ...' : 'Loading data into sandbox ...'
      });
      setTimeout(this.checkJobStatus, 5000);
    }
  },

  checkJobStatus() {
    if (!this.state.jobId) {
      return;
    }
    jobsApi
      .getJobDetail(this.state.jobId)
      .then(this.handleJobReceive)
      .catch((e) => {
        this.setState({
          isRunning: false
        });
        throw e;
      });
  },

  handleModalClose() {
    // reset state
    this.setState(this.getInitialState());
    this.props.onHide();
  }
});