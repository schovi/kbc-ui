import request from 'superagent';
import Promise from 'bluebird';
import {Request} from 'superagent';
import HttpError from './HttpError';
import qs from 'qs';

request.serialize['application/x-www-form-urlencoded'] = function(data) {
  return qs.stringify(data);
};

Request.prototype.promise = function() {
  var req = this;
  var promise = new Promise(function(resolve, reject) {
    return req.end(function(err, res) {
      if (err) {
        return reject(err);
      } else if (!res.ok) {
        return reject(new HttpError(res));
      } else {
        return resolve(res);
      }
    });
  });
  return promise.cancellable();
};

module.exports = function(method, url) {
  return request(method, url).timeout(60000);
};
