import callDockerAction from '../components/DockerActionsApi';

export default {
  generateKeys() {
    const params = {
      configData: []
    };
    return callDockerAction('keboola.ssh-keygen-v2', 'generate', params);
  }
};
