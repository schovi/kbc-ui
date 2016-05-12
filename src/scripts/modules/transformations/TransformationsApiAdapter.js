import request from '../../utils/request';
import ApplicationStore from '../../stores/ApplicationStore';
import ComponentsStore from '../components/stores/ComponentsStore';
import InstalledComponentsApi from '../components/InstalledComponentsApi';

var createUrl = function(path) {
  var baseUrl;
  baseUrl = ComponentsStore.getComponent('transformation').get('uri');
  return baseUrl + '/' + path;
};

var createRequest = function(method, path) {
  return request(method, createUrl(path)).set('X-StorageApi-Token', ApplicationStore.getSapiTokenString());
};

var transformationsApi = {

  // new
  getTransformationBuckets: function() {
    return InstalledComponentsApi.getComponentConfigurations('transformation').then(function(response) {
      // console.log(response);
      response.forEach(function() {
      });
      // TODO modify data
      return response;
    });
  },


  /* ---  OLD ---- */

  createTransformationBucket: function(data) {
    return createRequest('POST', 'configs').send(data).promise().then(function(response) {
      return response.body;
    });
  },

  deleteTransformationBucket: function(bucketId) {
    return createRequest('DELETE', 'configs/' + bucketId).send().promise();
  },

  getTransformations: function(bucketId) {
    return createRequest('GET', 'configs/' + bucketId + '/items').promise().then(function(response) {
      return response.body;
    });
  },

  deleteTransformation: function(bucketId, transformationId) {
    return createRequest('DELETE', 'configs/' + bucketId + '/items/' + transformationId).send().promise();
  },

  createTransformation: function(bucketId, data) {
    return createRequest('POST', 'configs/' + bucketId + '/items').send(data).promise().then(function(response) {
      return response.body;
    });
  },

  saveTransformation: function(bucketId, transformationId, data) {
    if (data.queriesString) {
      delete data.queriesString;
    }
    return createRequest('PUT', 'configs/' + bucketId + '/items/' + transformationId).send(data).promise().then(function(response) {
      return response.body;
    });
  },

  updateTransformationProperty: function(bucketId, transformationId, propertyName, propertyValue) {
    return createRequest('PUT', 'configs/' + bucketId + '/items/' + transformationId + '/' + propertyName).send(propertyValue).promise().then(function(response) {
      return response.body;
    });
  },

  getGraph: function(configuration) {
    var path;
    path = 'graph?table=' + configuration.tableId;
    path = path + ('&direction=' + configuration.direction);
    path = path + '&showDisabled=' + (configuration.showDisabled ? '1' : '0');
    path = path + '&limit=' + JSON.stringify(configuration.limit);
    return createRequest('GET', path).promise().then(function(response) {
      return response.body;
    });
  },

  getSqlDep: function(configuration) {
    return createRequest('POST', 'sqldep').send(configuration).promise().then(function(response) {
      return response.body;
    });
  }
};

module.exports = transformationsApi;
