import request from '../../utils/request';
import ApplicationStore from '../../stores/ApplicationStore';
import ComponentsStore from '../components/stores/ComponentsStore';

const createUrl = function(path) {
  const  baseUrl = ComponentsStore.getComponent('provisioning').get('uri');
  return baseUrl + '/' + path;
};

const createRequest = function(method, path, token) {
  var sapiToken = token;
  if (!sapiToken) {
    sapiToken = ApplicationStore.getSapiTokenString();
  }
  return request(method, createUrl(path)).set('X-StorageApi-Token', sapiToken);
};

module.exports = {
  getCredentials: function(backend, credentialsType, token) {
    return createRequest('GET', backend, token)
      .query({
        'type': credentialsType
      })
      .promise()
      .then(function(response) {
        return response.body;
      });
  },

  createCredentials: function(backend, credentialsType, token, data) {
    var requestData = data;
    if (!requestData) {
      requestData = {};
    }
    requestData.type = credentialsType;
    return createRequest('POST', backend, token)
      .send(requestData)
      .promise()
      .then(function(response) {
        return response.body;
      });
  },

  dropCredentials: function(backend, credentialsId, token) {
    return createRequest('DELETE', backend + '/' + credentialsId, token)
      .promise()
      .then(function(response) {
        return response.body;
      });
  }
};
