import request from '../../utils/request';
import ApplicationStore from '../../stores/ApplicationStore';
import ComponentsStore from '../components/stores/ComponentsStore';
import JobPoller from '../../utils/jobPoller';
// import later from 'later';

const createUrl = function(path) {
  const  baseUrl = ComponentsStore.getComponent('provisioning').get('uri');
  return baseUrl + '/' + path;
};

const createRequest = function(method, path) {
  const sapiToken = ApplicationStore.getSapiTokenString();
  return request(method, createUrl(path)).set('X-StorageApi-Token', sapiToken);
};

const ProvisioningApi = {
  getCredentials: function(backend, credentialsType) {
    return createRequest('GET', backend)
      .query({
        'type': credentialsType
      })
      .promise()
      .then(function(response) {
        return response.body;
      });
  },

  createCredentials: function(backend, credentialsType, data) {
    var requestData = data;
    if (!requestData) {
      requestData = {};
    }
    requestData.type = credentialsType;
    return createRequest('POST', backend)
      .send(requestData)
      .promise()
      .then(function(response) {
        return response.body;
      });
  },

  dropCredentials: function(backend, credentialsId) {
    return createRequest('DELETE', backend + '/' + credentialsId)
      .promise()
      .then(function(response) {
        return response.body;
      });
  },

  createCredentialsAsync: function(backend, credentialsType, data) {
    var requestData = data;
    if (!requestData) {
      requestData = {};
    }
    requestData.type = credentialsType;
    const sapiToken = ApplicationStore.getSapiTokenString();
    return createRequest('POST', 'async/' + backend)
      .send(requestData)
      .promise()
      .then(function(response) {
        return JobPoller.poll(sapiToken, response.body.url, 1000);
      })
      .then(function() {
        return ProvisioningApi.getCredentials('docker', credentialsType);
      });
  },

  dropCredentialsAsync: function(backend, credentialsId) {
    const sapiToken = ApplicationStore.getSapiTokenString();
    return createRequest('DELETE', 'async/' + backend + '/' + credentialsId)
      .promise()
      .then(function(response) {
        return JobPoller.poll(sapiToken, response.body.url, 1000);
      })
      .then(function(jobResult) {
        return jobResult.result;
      });
  }
};

module.exports = ProvisioningApi;
