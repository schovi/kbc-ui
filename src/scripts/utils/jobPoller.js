import Promise from 'bluebird';
import request from './request';
const _pollStatuses = ['processing', 'waiting'];

module.exports = {
  poll: function(token, url, interval) {
    var timeOutInterval = interval;
    if (timeOutInterval === null) {
      timeOutInterval = 5000;
    }
    return new Promise(function(resolve, reject) {
      var runRequest;
      runRequest = function() {
        return request('GET', url)
          .set('X-StorageApi-Token', token)
          .promise()
          .then(function(response) {
            if (_pollStatuses.indexOf(response.body.status) >= 0) {
              return setTimeout(runRequest, timeOutInterval);
            } else {
              return resolve(response.body);
            }
          }).catch(reject);
      };
      return runRequest();
    });
  }
};
