import request from '../../utils/request';
import parse from '../../utils/parseCsv';
import ApplicationStore from '../../stores/ApplicationStore';

var createUrl = function(path) {
  var baseUrl;
  baseUrl = ApplicationStore.getSapiUrl();
  return baseUrl + '/v2/storage/' + path;
};

var createRequest = function(method, path) {
  return request(method, createUrl(path)).set('X-StorageApi-Token', ApplicationStore.getSapiTokenString());
};

var storageApi = {

  getBuckets: function() {
    return createRequest('GET', 'buckets').promise().then(function(response) {
      return response.body;
    });
  },

  getBucketCredentials: function(bucketId) {
    return createRequest('GET', 'buckets/' + bucketId + '/credentials').promise().then(function(response) {
      return response.body;
    });
  },

  createBucketCredentials: function(bucketId, name) {
    return createRequest('POST', 'buckets/' + bucketId + '/credentials').type('form').send({
      name: name
    }).promise().then(function(response) {
      return response.body;
    });
  },

  deleteBucketCredentials: function(credentialsId) {
    return createRequest('DELETE', 'credentials/' + credentialsId).promise().then(function(response) {
      return response.body;
    });
  },

  getTables: function() {
    return createRequest('GET', 'tables?include=attributes,buckets,columns').promise().then(function(response) {
      return response.body;
    });
  },
  createToken: function(params) {
    return createRequest('POST', 'tokens').type('form').send(params).promise().then(function(response) {
      return response.body;
    });
  },

  getTokens: function() {
    return createRequest('GET', 'tokens').promise().then(function(response) {
      return response.body;
    });
  },

  getFiles: function(params) {
    return createRequest('GET', 'files').query(params).promise().then(function(response) {
      return response.body;
    });
  },

  getRunIdStats: function(runId) {
    return createRequest('GET', 'stats').query({
      runId: runId
    }).promise().then(function(response) {
      return response.body;
    });
  },

  getKeenCredentials: function() {
    return createRequest('GET', 'tokens/keen').promise().then(function(response) {
      return response.body;
    });
  },

  /*
    Returns parsed CSV info plain arrays
    [
      [] - row 1
      [] - row 2
    ]
   */
  exportTable: function(tableId, params) {
    return createRequest('GET', 'tables/' + tableId + '/export').query(params).promise().then(function(response) {
      return parse(response.text);
    });
  },

  prepareFileUpload: function(params) {
    return createRequest('POST', 'files/prepare').type('form').send(params).promise().then(function(response) {
      return response.body;
    });
  },

  createBucket: function(params) {
    return createRequest('POST', 'buckets').type('form').send(params).promise().then(function(response) {
      return response.body;
    });
  },

  createTable: function(bucketId, params) {
    return createRequest('POST', 'buckets/' + bucketId + '/tables-async').type('form').send(params).promise().then(function(response) {
      return response.body;
    });
  },

  loadTable: function(tableId, params) {
    return createRequest('POST', 'tables/' + tableId + '/import-async').type('form').send(params).promise().then(function(response) {
      return response.body;
    });
  }
};

module.exports = storageApi;
